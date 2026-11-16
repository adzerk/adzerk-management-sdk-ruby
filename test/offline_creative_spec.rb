require File.expand_path(File.dirname(__FILE__) + '/offline_helper')

describe "Creative API (offline)", :offline do
  let(:client) { Adzerk::Client.new('offline-test-key') }
  let(:base_url) { "#{Adzerk::Client::DEFAULTS[:host]}v1" }
  let(:creative_data) { { :title => 'Test creative', :advertiser_id => 7 } }
  # WebMock does not expose bodies set with Net::HTTP#set_form, so these examples can check that a multipart upload
  # was made, and with which headers, but not the multipart body itself.
  let(:image_path) { File.expand_path(File.dirname(__FILE__) + '/250x250.gif') }

  def stub_and_capture(url, body, status = 200)
    requests = []
    stub_request(:post, url).to_return do |request|
      requests << request
      { :status => status, :body => body.to_json }
    end
    requests
  end

  # Responds with each [status, body] in turn, repeating the last one if more requests arrive.
  def stub_post_sequence(url, *responses)
    requests = []
    stub_request(:post, url).to_return do |request|
      requests << request
      status, body = responses.size > 1 ? responses.shift : responses.first
      { :status => status, :body => body.to_json }
    end
    requests
  end

  describe "creating a creative without an image" do
    it "posts the creative as urlencoded JSON with the api key and sdk version headers" do
      requests = stub_and_capture("#{base_url}/creative", 'Id' => 42)

      client.creatives.create(creative_data)

      expect(requests.size).to eq(1)
      request = requests.first
      expect(request.headers['Content-Type']).to eq('application/x-www-form-urlencoded')
      expect(request.headers['X-Adzerk-Apikey']).to eq('offline-test-key')
      expect(request.headers['X-Adzerk-Sdk-Version']).to eq(Adzerk::Client::SDK_HEADER_VALUE)
      form = URI.decode_www_form(request.body).to_h
      expect(JSON.parse(form['creative'])).to eq('Title' => 'Test creative', 'AdvertiserId' => 7)
    end

    it "returns the created creative with uncamelized symbol keys" do
      stub_and_capture("#{base_url}/creative", 'Id' => 42, 'Title' => 'Test creative', 'AdvertiserId' => 7)

      creative = client.creatives.create(creative_data)

      expect(creative).to eq(:id => 42, :title => 'Test creative', :advertiser_id => 7)
    end
  end

  describe "creating a creative with an image" do
    it "creates the creative, then uploads the image to it" do
      create_requests = stub_and_capture("#{base_url}/creative", 'Id' => 42)
      upload_requests = stub_and_capture("#{base_url}/creative/42/upload", 'Id' => 42, 'ImageName' => '250x250.gif')

      creative = client.creatives.create(creative_data, image_path)

      expect(create_requests.size).to eq(1)
      expect(upload_requests.size).to eq(1)
      expect(creative).to eq(:id => 42, :image_name => '250x250.gif')
    end
  end

  describe "uploading an image to an existing creative" do
    it "posts as multipart form data with the api key and sdk version headers" do
      requests = stub_and_capture("#{base_url}/creative/42/upload", 'Id' => 42)

      client.upload_creative(42, image_path)

      expect(requests.size).to eq(1)
      request = requests.first
      expect(request.headers['Content-Type']).to start_with('multipart/form-data')
      expect(request.headers['X-Adzerk-Apikey']).to eq('offline-test-key')
      expect(request.headers['X-Adzerk-Sdk-Version']).to eq(Adzerk::Client::SDK_HEADER_VALUE)
    end

    it "returns a response whose body is the API's JSON" do
      stub_and_capture("#{base_url}/creative/42/upload", 'Id' => 42, 'ImageName' => '250x250.gif')

      response = client.upload_creative(42, image_path)

      expect(JSON.parse(response.body)).to eq('Id' => 42, 'ImageName' => '250x250.gif')
    end

    it "asks the API to override the size when size_override is true" do
      requests = stub_and_capture("#{base_url}/creative/42/upload?sizeOverride=true", 'Id' => 42)

      client.upload_creative(42, image_path, size_override: true)

      expect(requests.size).to eq(1)
    end
  end

  describe "error responses from the creative calls" do
    before { allow(client).to receive(:sleep) }

    it "retries a 429 from creating a creative and returns the response that follows" do
      requests = stub_post_sequence("#{base_url}/creative", [429, { 'message' => 'slow down' }], [200, { 'Id' => 42 }])

      creative = client.creatives.create(creative_data)

      expect(requests.size).to eq(2)
      expect(creative).to eq(:id => 42)
    end

    it "retries a 429 from uploading an image" do
      requests = stub_post_sequence("#{base_url}/creative/42/upload",
                                    [429, { 'message' => 'slow down' }], [200, { 'Id' => 42 }])

      client.upload_creative(42, image_path)

      expect(requests.size).to eq(2)
    end

    it "raises an ApiError carrying the API's message on a 4xx from creating a creative" do
      requests = stub_post_sequence("#{base_url}/creative", [400, { 'message' => 'bad creative' }])

      expect { client.creatives.create(creative_data) }.to raise_error(Adzerk::ApiError, 'bad creative')
      expect(requests.size).to eq(1)
    end

    it "raises an ApiError carrying the API's message on a 4xx from uploading an image" do
      requests = stub_post_sequence("#{base_url}/creative/42/upload", [400, { 'message' => 'bad image' }])

      expect { client.upload_creative(42, image_path) }.to raise_error(Adzerk::ApiError, 'bad image')
      expect(requests.size).to eq(1)
    end
  end
end

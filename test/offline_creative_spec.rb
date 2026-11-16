require File.expand_path(File.dirname(__FILE__) + '/offline_helper')

describe "Creative API (offline)", :offline do
  let(:client) { Adzerk::Client.new('offline-test-key') }
  let(:base_url) { "#{Adzerk::Client::DEFAULTS[:host]}v1" }
  let(:creative_data) { { :title => 'Test creative', :advertiser_id => 7 } }
  # Binary on purpose. Note that rspec 3.5.0 (pinned in the gemspec) crashes on Ruby 3 while printing a failure
  # message that contains non-UTF-8 bytes, so a multipart request to a URL that isn't stubbed ends the run with a
  # TypeError instead of a failure report.
  let(:image_path) { File.expand_path(File.dirname(__FILE__) + '/250x250.gif') }

  def stub_and_capture(url, body, status = 200)
    requests = []
    stub_request(:post, url).to_return do |request|
      requests << request
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
    it "posts the image as multipart form data with the api key and sdk version headers" do
      requests = stub_and_capture("#{base_url}/creative/42/upload", 'Id' => 42)

      client.upload_creative(42, image_path)

      expect(requests.size).to eq(1)
      request = requests.first
      expect(request.headers['Content-Type']).to start_with('multipart/form-data; boundary=')
      expect(request.headers['X-Adzerk-Apikey']).to eq('offline-test-key')
      expect(request.headers['X-Adzerk-Sdk-Version']).to eq(Adzerk::Client::SDK_HEADER_VALUE)
      # Assert on small derived values: a failing `include` on the binary body would dump the whole GIF.
      part_header = request.body.b[/Content-Disposition: form-data; name="[^"]*"; filename="[^"]*"/]
      expect(part_header).to eq('Content-Disposition: form-data; name="image"; filename="250x250.gif"')
      expect(request.body.b.include?(File.binread(image_path))).to be(true)
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

  # These examples record how the two rest-client calls behave today, including that a 429 is never retried
  # because rest-client raises on any non-2xx response. They change when rest-client is removed.
  describe "error responses from the creative calls (current rest-client behavior)" do
    it "raises on a 429 from creating a creative instead of retrying" do
      requests = stub_and_capture("#{base_url}/creative", { 'message' => 'slow down' }, 429)

      expect { client.creatives.create(creative_data) }.to raise_error(RestClient::TooManyRequests)
      expect(requests.size).to eq(1)
    end

    it "raises on a 429 from uploading an image instead of retrying" do
      requests = stub_and_capture("#{base_url}/creative/42/upload", { 'message' => 'slow down' }, 429)

      expect { client.upload_creative(42, image_path) }.to raise_error(RestClient::TooManyRequests)
      expect(requests.size).to eq(1)
    end

    it "raises a rest-client error on a 4xx from creating a creative" do
      stub_and_capture("#{base_url}/creative", { 'message' => 'bad creative' }, 400)

      expect { client.creatives.create(creative_data) }.to raise_error(RestClient::BadRequest)
    end
  end
end

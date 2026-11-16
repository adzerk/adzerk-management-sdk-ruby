require File.expand_path(File.dirname(__FILE__) + '/offline_helper')

describe "Client request handling (offline)", :offline do
  let(:client) { Adzerk::Client.new('offline-test-key') }
  let(:site_url) { "#{Adzerk::Client::DEFAULTS[:host]}v1/site/1" }

  def stub_responses(url, *responses)
    requests = []
    stub_request(:get, url).to_return do |request|
      requests << request
      status, body = responses.shift
      { :status => status, :body => body.to_json }
    end
    requests
  end

  it "sends the api key and sdk version headers" do
    requests = stub_responses(site_url, [200, { 'Id' => 1 }])

    client.sites.get(1)

    expect(requests.first.headers['X-Adzerk-Apikey']).to eq('offline-test-key')
    expect(requests.first.headers['X-Adzerk-Sdk-Version']).to eq(Adzerk::Client::SDK_HEADER_VALUE)
  end

  it "retries a 429 and returns the response that follows" do
    allow(client).to receive(:sleep)
    requests = stub_responses(site_url, [429, { 'message' => 'slow down' }], [200, { 'Id' => 1, 'Title' => 'Site' }])

    site = client.sites.get(1)

    expect(requests.size).to eq(2)
    expect(site).to eq(:id => 1, :title => 'Site')
  end

  it "sleeps between retries" do
    allow(client).to receive(:sleep)
    stub_responses(site_url, [429, { 'message' => 'slow down' }], [200, { 'Id' => 1 }])

    client.sites.get(1)

    expect(client).to have_received(:sleep).once
  end

  it "raises an ApiError carrying the API's message on a 4xx, without retrying" do
    requests = stub_responses(site_url, [400, { 'message' => 'bad site' }])

    expect { client.sites.get(1) }.to raise_error(Adzerk::ApiError, 'bad site')
    expect(requests.size).to eq(1)
  end
end

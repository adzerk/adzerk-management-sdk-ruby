require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Report API" do

  before do
    @reports = Adzerk::Client.new(API_KEY).reports

    $new_report = {
      :start_date => "1/15/2011",
      :end_date => "12/31/2011",
      :group_by => ['month'],
      'Top30countries' => false,
      :exclude_3rd_party => false,
      :is_total => true,
      :parameters => []
    }
  end

  it "should create a report" do
    report = @reports.create_report($new_report)
    #expect(report.has_key? :id).to be true
    expect(report[:is_total]).to be true
    expect(report[:grouping]).to eq ["month"]
  end

  it "should create a queued report" do
    response = @reports.create_queued_report($new_report)
    $saved_report_id = response[:id]
    expect($saved_report_id).to_not be_nil
  end

  it "should poll for the result of a queued report" do
    response = @reports.retrieve_queued_report($saved_report_id)
    expect(response[:id]).to eq $saved_report_id
    expect([1,2,3]).to include response[:status]
  end

  it "should return a status of 1 if the report isn't ready yet" do
    bigger_report = $new_report.update(start_date: "1/1/2010", end_date: "10/1/2014")
    report_id = @reports.create_queued_report(bigger_report)[:id]
    # immediately poll for the result
    response = @reports.retrieve_queued_report(report_id)
    expect(response[:status]).to eq 1
  end

  it "should retrieve a queued report if available" do
    # use $saved_report_id from 3 tests ago, wait a couple seconds to make sure the report is ready
    sleep 2
    response = @reports.retrieve_queued_report($saved_report_id)
    expect(response[:status]).to eq 2
    expect(response[:result][:is_total]).to be true
    expect(response[:result][:grouping]).to eq ["month"]
  end
end


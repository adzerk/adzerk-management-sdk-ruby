require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Report API" do
  
  before do
    @reports = Adzerk::Client.new(API_KEY).reports
  end

  it "create a report" do
    new_report = {
      :start_date => "1/15/2011",
      :end_date => "12/31/2011",
      :group_by => ['month'],
      'Top30countries' => false,
      :exclude_3rd_party => false,
      :is_total => true,
      :parameters => []
    }
    report = @reports.create_report(new_report)
    report[:is_total].should eq(true)
    report[:grouping].should eq(["month"])
  end

  it "should pull a saved custom report" do
    pending
    $savedReportId = 5280
    response = @reports.retrieve_report($savedReportId.to_s)
    csv_report = response.body
  end      
end


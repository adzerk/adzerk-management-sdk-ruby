require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Report API" do
  
  $report_url = 'http://www.adzerk.com/'
  @@report = $adzerk::Reporting.new

  it "create a report" do
    $startdate = "1/15/2011"
    $enddate = "12/31/2011"
    $groupby = ["month"]
    $top30 = false
    $exclude3rd = false
    $istotal = true
    $params = []
    new_report = {
      'StartDate' => $startdate,
      'EndDate' => $enddate,
      'GroupBy' => $groupby,
      'Top30countries' => $top30,
      'Exclude3rdParty' => $exclude3rd,
      'IsTotal' => $istotal,
      'Parameters' => $params
    }
    response = @@report.create_report(new_report)
    # response.body.should == '{"StartDate":"\/Date(1295067600000-0500)\/","EndDate":"\/Date(1325307600000-0500)\/","Critiera":[],"LoginId":0,"Records":[],"OptionRecords":[],"IsTotal":true,"Grouping":["month"],"TotalImpressions":0,"TotalClicks":0,"TotalCTR":0}'
  end


  it "should pull a saved custom report" do
    $savedReportId = 5280
    response = @@report.get($savedReportId.to_s)

    csv_report = response.body
  end      
end


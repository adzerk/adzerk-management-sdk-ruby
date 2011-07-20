require 'spec_helper'

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
    puts new_report.to_json
    response = @@report.create_report(new_report)
    puts response.body
  end

  
end
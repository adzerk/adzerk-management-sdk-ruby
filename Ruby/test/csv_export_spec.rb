require 'spec_helper'

describe "(Saved) Report API" do
  
  $report_url = 'http://www.adzerk.com/'
  @@report = $adzerk::Reporting.new
  $savedReportId = 5290
  @@response = @@report.get($savedReportId.to_s)
  @@csv_export = @@response.body
  @@first_data_line = ""

  before(:all) do
    @@csv_export.each_line do |line|
      if line.start_with?("6/9/2012")
        @@first_data_line = line
      end
    end
  end

  it "should pull a saved custom report" do
    @@response.code.should == "200"
  end 

  it "should contain start and end date headers" do
    @@csv_export.should include("Start Date")
    @@csv_export.should include("End Date")
  end    

  it "should include column header for brand" do
    @@csv_export.should include("Brand")
  end 

  it "should include column header for date" do
    @@csv_export.should include("Date")
  end

  it "should include column header for campaign" do
    @@csv_export.should include("Campaign")
  end

  it "should include column header for option" do
    @@csv_export.should include("Option")
  end

  it "should include column header for creative" do
    @@csv_export.should include("Channel")
  end

  it "should include column header for priority" do
    @@csv_export.should include("Priority")
  end

  it "should include column header for adtype" do
    @@csv_export.should include("AdType")
  end

  it "should include column header for site" do
    @@csv_export.should include("Site")
  end

  it "should include column header for country" do
    @@csv_export.should include("Country")
  end

  it "should include column header for impressions" do
    @@csv_export.should include("Impressions")
  end

  it "should include column header for clicks" do
    @@csv_export.should include("Clicks") 
  end

  it "should include column header for click-through-rate" do
    @@csv_export.should include("CTR")
  end

  it "should include column header for revenue" do
    @@csv_export.should include("Revenue")
  end

  it "should have data lines with every data column present" do

    fields = @@first_data_line.split(',')

    fields.count.should eq(15)

  end
  
end

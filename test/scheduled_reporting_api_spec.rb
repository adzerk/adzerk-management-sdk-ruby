require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Reporting API" do
    before(:all) do
        client = Adzerk::Client.new(API_KEY)
        @scheduled_reports = client.scheduled_reports
    end

    it "should create a scheduled report" do
        $name = 'Test Report' + rand(1000000).to_s
        $login_id = 25218
        $kickoff_date = '2020-02-02T00:00:00'
        $scheduling_window = 1
        $recurrence_type = 2
        data = {
            :name => $name,
            :login_id => $login_id,
            :kickoff_date => $kickoff_date,
            :scheduling_window => $scheduling_window,
            :recurrence_type => $recurrence_type,
            :criteria => {
                :start_date_iso => '2020-01-01T00:00:00',
                :end_date_iso => '2020-11-23T23:59:59',
                :group_by => ['month'],
                :parameters => [{
                :country_code => 'US'
                }],
            },
            :emails => ['cbensel@kevel.co'],
            :show_events => true,
            :show_click_bucketing => true,
            :show_revenue => true,
            :show_conversions => true,
        }

        response = @scheduled_reports.create(data)
        expect($name).to eq(response[:name])
        expect($login_id).to eq(response[:login_id])
        expect($kickoff_date).to eq(response[:kickoff_date])
        expect($scheduling_window).to eq(response[:scheduling_window])
        expect($recurrence_type).to eq(response[:recurrence_type])
        $report_id = response[:id]
    end

    it "should get a single report" do
        response = @scheduled_reports.get($report_id)
        expect($report_id).to eq(response[:id])
        expect($name).to eq(response[:name])
    end

    it "should list all reports for account" do 
        response = @scheduled_reports.list()
        expect(response.length).to be > 0
    end

    it "should delete a report" do
        response = @scheduled_reports.delete($report_id)
        expect(response).to eq('Successfully deleted')
    end
end
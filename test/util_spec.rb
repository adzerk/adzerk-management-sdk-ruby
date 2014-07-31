require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Adzerk::Util do
  describe "#camelize_data(data)" do
    it "doesn't camelize keys when they are strings" do
      data = {'No_CAMELcaseString' => 1234}
      result = Adzerk::Util.camelize_data(data)
      expect(result['No_CAMELcaseString']).to eql(1234)
    end

    it "camelizes keys when they are symbols" do
      data = {:'No_CAMEL_case_Symbol' => 1234}
      result = Adzerk::Util.camelize_data(data)
      expect(result['NoCamelCaseSymbol']).to eql(1234)
    end
  end
end

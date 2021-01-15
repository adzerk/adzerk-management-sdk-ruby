require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Creative Template API" do

  before do
    @creative_templates = Adzerk::Client.new(API_KEY).creative_templates
  end

  it "should create a new creative template" do
    expected = {
      description: 'Creative Template Description',
      name: 'API Test Creative Template Name 1',
      is_archived: false,
      fields: [{
        name: 'Title',
        description: 'The Creative Template Title',
        type: 'String',
        variable: 'ctTitle',
        required: true,
      }, {
        name: 'Thumbnail',
        description: 'The URL of a Thumbnail Image',
        type: 'String',
        variable: 'ctThumbnailUrl',
        required: false,
      }],
      contents: [{
        type: 'Raw',
        body: '{"title": "{{ctTitle}}", "thumbnailUrl": "{{ctThumbnailUrl}}" }'
      }]
    }

    result = @creative_templates.create(expected)

    $creative_template_id = result[:id].to_s

    expect(result).to include(:id)
    expect(result[:description]).to eq(expected[:description])
    expect(result[:name]).to eq(expected[:name])
    expect(result[:is_archived]).to eq(expected[:is_archived])
    expect(result[:fields]).to match_array(expected[:fields])
  end

  it "should list existing creative templates" do
    result = @creative_templates.list

    expect(result[:page]).to eq(1)
    expect(result[:page_size]).to eq(100)
    expect(result[:total_items]).to be >= 1
  end

  it "should get an existing creative template" do
    expected = {
      description: 'Creative Template Description',
      name: 'API Test Creative Template Name 1',
      is_archived: false,
      fields: [{
        name: 'Title',
        description: 'The Creative Template Title',
        type: 'String',
        variable: 'ctTitle',
        required: true,
      }, {
        name: 'Thumbnail',
        description: 'The URL of a Thumbnail Image',
        type: 'String',
        variable: 'ctThumbnailUrl',
        required: false,
      }],
      contents: [{
        type: 'Raw',
        body: '{"title": "{{ctTitle}}", "thumbnailUrl": "{{ctThumbnailUrl}}" }'
      }]
    }

    result = @creative_templates.get($creative_template_id)

    expect(result[:description]).to eq(expected[:description])
    expect(result[:name]).to eq(expected[:name])
    expect(result[:is_archived]).to eq(expected[:is_archived])
    expect(result[:fields]).to match_array(expected[:fields])
  end

  it "should update an existing creative template" do
    update = {
      updates: [{
        path: ['IsArchived'],
        value: true
      }]
    }

    result = @creative_templates.update($creative_template_id, update)

    expect(result[:is_archived]).to eq(true)
  end
end
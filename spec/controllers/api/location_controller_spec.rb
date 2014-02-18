require 'spec_helper'

describe Api::LocationController do
  it 'has a valid :user factory' do
    expect(create(:location)).to be_valid
  end

  describe "GET 'index'" do
    before do
      @locations = create_list(:location, 20)
      get 'index'
    end

    it 'returns http success' do
      response.should be_success
    end

    context 'there are 20 locations' do
      it 'returns 20 items' do
        json = JSON.parse(response.body)
        expect(json).to have(20).items
      end
    end
  end

end

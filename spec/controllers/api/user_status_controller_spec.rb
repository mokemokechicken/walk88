require 'spec_helper'

describe Api::UserStatusController do
  it 'should have valid factory' do
    user = create(:user)
    expect(user.id).to eq user.user_status.user_id
    expect(user.user_setting.reverse_mode).to eq UserSetting::NORMAL_MODE
  end


  context 'there are 2 users' do
    before do
      @users = create_list(:user, 2)
    end

    describe "GET 'index'" do
      before do
        get 'index'
        @json = JSON.parse(response.body)
      end

      it "returns http success" do
        get 'index'
        response.should be_success
      end

      it 'return 2 items' do
        expect(@json).to have(2).items
      end

      it 'return json array' do
        expect(@json[0]).to include('image')
      end
    end

    describe "GET 'show'" do
      before do
        get 'show', :id => @users[1]
      end

      it 'returns http success' do
        response.should be_success
      end

      it 'returns user and user_status json' do
        expect(response.body).to eq @users[1].user_status.to_json
      end
    end
  end
end

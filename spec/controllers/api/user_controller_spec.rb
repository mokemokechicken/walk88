require 'spec_helper'

describe Api::UserController do
  it 'has a valid :user factory' do
    expect(create(:user)).to be_valid
  end

  describe "GET 'index'" do
    it 'returns http success' do
      get 'index'
      response.should be_success
    end

    context 'there are 2 users' do
      before do
        @user_list = [create(:user), create(:user)]
      end

      it 'returns 2 items' do
        get :index
        json = JSON.parse(response.body)
        expect(json).to have(2).items
      end

      it 'matches user list' do
        get :index
        expect(response.body ).to eq @user_list.to_json
      end
    end
  end

  describe "GET 'show'" do
    context 'there are 2 users' do
      before do
        @user_list = [create(:user), create(:user)]
      end
      it 'returns http success' do
        get 'show', :id => 1
        response.should be_success
      end

      it 'return the id user as json' do
        u = @user_list[1]
        get 'show', :id => u.id
        expect(response.body).to eq u.to_json
      end
    end
  end
end

require 'spec_helper'

describe GroupRanking2 do

  it 'has a valid :group factory' do
    expect(create(:group)).to be_valid
  end

  it 'has a valid :group_user factory' do
    expect(create(:group_user)).to be_valid
  end

  it 'has a valid :user_record factory' do
    expect(create(:user_record)).to be_valid
  end

  def create_data
    @g1 = g1 = create(:group)
    @g2 = g2 = create(:group)
    create(:group_user, :group_id => g1.id, :user_id => 1)  # distance=1, 2, 3
    create(:group_user, :group_id => g1.id, :user_id => 2)  # distance=2, 3, 4
    create(:group_user, :group_id => g2.id, :user_id => 3)  # distance=3, 4, 5
    create(:group_user, :group_id => g2.id, :user_id => 4)  # distance=4, 5, 6
    [1,2,3,4].each do |user_id|
      create(:user_record, :user_id => user_id, :day => '2013-12-01', :distance => user_id)
      create(:user_record, :user_id => user_id, :day => '2013-12-02', :distance => user_id+1)
      create(:user_record, :user_id => user_id, :day => '2013-12-03', :distance => user_id+2)
    end
  end

  def replace_calc_distance
    GroupRanking2.stub(:calc_distance) {|dlist| dlist.reduce(:+) * 2}  # 距離合計の２倍を返すだけにする
  end

  describe 'calc_distance' do
    it 'should calc distance' do
      expect(GroupRanking2.calc_distance([100,110,120]).to_i).to eq(626)
    end
  end

  describe 'ranking_list' do
    before do
      create_data
      replace_calc_distance
    end

    subject { GroupRanking2.ranking_list('2013-12-01', '2013-12-04') }

    it { expect(subject).to have(2).items }

    describe "check the g1 distance" do
      it "should be g1" do
        expect(subject[1]['name']).to eq(@g1.name)
      end

      it "should be 30" do
        expect(subject[1]['distance']).to eq(30)
      end
    end

    describe "check the g2 distance" do
      it "should be g2" do
        expect(subject[0]['name']).to eq(@g2.name)
      end

      it "should be 54" do
        expect(subject[0]['distance']).to eq(54)
      end
    end
  end

  describe 'ranking_list_by_day' do
    before do
      create_data
      replace_calc_distance
    end

    subject { GroupRanking2.ranking_list_by_day('2013-12-01', '2013-12-04') }

    it 'should have 2 items' do
      expect(subject).to have(2).items
    end

    it 'should have 3 day items in each group' do
      expect(subject[0]).to have(3).items
      expect(subject[1]).to have(3).items
    end

    describe 'second item' do
      before do
        @data = subject[1]
      end

      it 'should be g2 data' do
        expect(@data[0]['name']).to eq(@g2.name)
      end

      describe '1st day distance' do
        it {expect(@data[0]['distance']).to eq(14)}
      end
      describe '2nd day distance' do
        it {expect(@data[1]['distance']).to eq(32)}
      end
      describe '3rd day distance' do
        it {expect(@data[2]['distance']).to eq(54)}
      end
    end

    describe 'first item' do
      before do
        @data = subject[0]
      end

      it 'should be g1 data' do
        expect(@data[0]['name']).to eq(@g1.name)
      end

      describe '1st day distance' do
        it {expect(@data[0]['distance']).to eq(6)}
      end
      describe '2nd day distance' do
        it {expect(@data[1]['distance']).to eq(16)}
      end
      describe '3rd day distance' do
        it {expect(@data[2]['distance']).to eq(30)}
      end
    end


  end
end
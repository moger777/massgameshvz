require 'spec_helper'

describe Vaccine do
  describe "#take" do
    let(:current_game){Factory(:current_game)}
    let(:vaccine){Factory(:vaccine, :code => 'abc123', :used => false)}
    
    let(:zombie_participation) do
      Factory(:game_participation,
        :creature => Zombie::NORMAL,
        :game => current_game
      )
    end
    
    let(:human_participation) do
      Factory(:game_participation,
        :creature => Human::Normal,
        :game => current_game
      )
    end
    
    before do
      Timecop.freeze(current_game.start_at)
    end

    after do
      Timecop.return
    end
    
    it "should turn a zombie participation into a human" do
      vaccine.take(zombie_participation)
      zombie_participation.creature.should == Human::NORMAL
    end
    
    it "changes zombie participations user number" do
      original_number = zombie_participation.user_number
      vaccine.take(zombie_participation)
      zombie_participation.user_number.should_not == original_number
    end
    
    it "should not let a human participation take vaccine" do
      vaccine.take(human_participation)
      vaccine.used.should_not be_true
    end
    
    it "should not let anyone take vaccine if used" do
      vaccine.take(zombie_participation)
      another_zombie_participation = Factory(:game_participation,
        :creature => Zombie::NORMAL,
        :game => current_game
      )
      vaccine.take(another_zombie_participation)
      another_zombie_participation.creature.should_not == Human::NORMAL
    end
  end
end
class Event < ActiveRecord::Base
  belongs_to :game_participation
  belongs_to :target_object, :polymorphic => true
  
  before_save :set_occured_at
  
  def self.belongs_to_game_participation(game_participation)
    where(
      "
        events.game_participation_id = ? OR
        (
          events.target_object_type = ? AND
          events.target_object_id = ?
        )
      ", game_participation.id, 'GameParticipation', game_participation.id
    )
  end
  
  def set_occured_at
    self.occured_at = Time.now unless self.occured_at
  end
end

class Relationship < ActiveRecord::Base
  attr_accessible :followed_id, :follower_id
  
  validates :followed_id, presence: true
  validates :follower_id, presence: true,
						  uniqueness: { scope: :followed_id }
  
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  
end

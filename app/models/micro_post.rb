class MicroPost < ActiveRecord::Base
  attr_accessible :content, :user_id
  
  belongs_to :user
  
  validates :content, presence: true,
                      length: { minimum: 5, maximum: 140 }

  validates :user_id, presence: true
  
  after_create :send_mentions_email
    
  def send_mentions_email
    mentions.each do |mentioned_user|
      UserMailer.mentioned(self, mentioned_user).deliver
    end
  end
  
  def mentions
    results = []
    content.scan(/@[^@]+@/) do |match|
      name = match[1..match.length - 2]
      mentioned_user = User.find_by_name(name)
	  results << mentioned_user if mentioned_user && mentioned_user != user
    end

    results
  end
end



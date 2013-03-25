class MicroPost < ActiveRecord::Base
  attr_accessible :content, :user_id
  
  belongs_to :user
  
  validates :content, presence: true,
                      length: { minimum: 5, maximum: 140 }

  validates :user_id, presence: true

  after_create :send_mentions_email

  def mentions
    results = []
    content.scan(/@[^@]+@/) do |name|
      name = name[1..name.length - 2]
      u = User.find_by_name(name)
      results << u if u
    end

    results
  end

  def send_mentions_email
    mentions.each do |mentioned_user|
      UserMailer.mentioned(self, mentioned_user).deliver
    end
  end
end

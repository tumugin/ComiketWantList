class User
  include Mongoid::Document
  field :Name
  field :Password
  field :UserID
  field :MailAdress
  field :created_at, :type => DateTime, :default => lambda{Time.now}
  embeds_many :UserWantList

  def AuthPassword(pass)
    if Digest::SHA512.hexdigest(pass) == self.Password
        return true
    else
        return false
    end
  end
end

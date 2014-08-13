class UserWantList
  include Mongoid::Document
  field :Name
  field :created_at, :type => DateTime, :default => lambda{Time.now}
  embeds_many :Item
  embedded_in :user, :inverse_of => :UserWantList
end

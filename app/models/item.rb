class Item
  include Mongoid::Document
  field :Name
  field :Price, type: Integer
  field :Description
  field :Circle
  field :Place
  field :created_at, :type => DateTime, :default => lambda{Time.now}
  embedded_in :UserWantList, :inverse_of => :Item
  embeds_many :Comment
end

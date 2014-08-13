class Comment
  include Mongoid::Document
  field :Text
  field :OwnerUserID
  field :created_at, :type => DateTime, :default => lambda{Time.now}
  embedded_in :Item, :inverse_of => :Comment
end

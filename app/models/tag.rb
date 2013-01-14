class Tag < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true, length: {maximum: 20}
  belongs_to :taggable, polymorphic: true
end

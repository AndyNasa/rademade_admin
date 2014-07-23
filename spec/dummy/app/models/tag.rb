# -*- encoding : utf-8 -*-
class Tag
  include Mongoid::Document
  include Sortable

  field :name, :type => String
  has_and_belongs_to_many :posts

  def to_s
    name
  end

end

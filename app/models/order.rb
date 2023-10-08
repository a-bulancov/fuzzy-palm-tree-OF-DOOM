class Order < ApplicationRecord
  belongs_to :user

  def serialize
    attrs = attributes
    attrs["user_id"] = user.name
    attrs.values
  end
end

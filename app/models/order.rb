class Order < ApplicationRecord
  belongs_to :user

  def serialize
    attrs = attributes.dup
    attrs["user_name"] = user.name
    attrs.delete "user_id"
    attrs
  end
end

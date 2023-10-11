require "dry/schema"

OrderSchema = Dry::Schema.Params do
  required(:start_date).filled(:date)
  required(:end_date).filled(:date)
  optional(:user_name).filled(:string)
  optional(:sum).filled(:float)
end

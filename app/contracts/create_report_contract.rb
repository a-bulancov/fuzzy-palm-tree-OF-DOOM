class CreateReportContract < Dry::Validation::Contract
  params do
    required(:username).filled(:string)
    required(:from_price).filled(:decimal)
    required(:to_price).filled(:decimal)
  end
end

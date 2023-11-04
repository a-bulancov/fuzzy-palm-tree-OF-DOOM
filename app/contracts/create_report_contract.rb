class CreateReportContract < Dry::Validation::Contract
  params do
    optional(:username).filled(:string)
    optional(:from_price).filled(:decimal)
    optional(:to_price).filled(:decimal)
  end
end

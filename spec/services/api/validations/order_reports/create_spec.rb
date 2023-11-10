# frozen_string_literal: true

RSpec.describe Api::Validations::OrderReports::Create do
  it "requires user_ids or amount" do
    expect(subject.call({}).errors.to_h).to(
      include(
        user_id_in_or_amount_eq: [
          "must at least contain one of: user_id_in, amount_eq"
        ]
      )
    )
    expect(subject.call({user_id_in: [1, 2, 3]}).errors.to_h).to_not(
      include(
        user_ids_or_amount: [
          "must at least contain one of: user_id_in, amount_eq"
        ]
      )
    )
    expect(subject.call({amount_eq: 100}).errors.to_h).to_not(
      include(
        user_ids_or_amount: [
          "must at least contain one of: user_id_in, amount_eq"
        ]
      )
    )
  end

  it "requires user_ids must be filled" do
    expect(subject.call({user_id_in: []}).errors.to_h).to(
      include(user_id_in: ["must be filled"])
    )
  end
end

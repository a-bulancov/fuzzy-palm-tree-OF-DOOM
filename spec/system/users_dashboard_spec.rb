# frozen_string_literal: true

RSpec.describe 'Users Dashboard', js: true do
  let(:user_with_items) { create(:user) }
  let(:order_with_items) { create(:order, :with_items, user: user_with_items) }

  let(:user_without_items) { create(:user) }
  let(:order_without_items) { create(:order, user: user_without_items) }
end

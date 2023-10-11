# frozen_string_literal: true

RSpec.describe Orders::IndexQuery do
  let(:users) { { john_cena: create(:john_cena), razrushitel: create(:razrushitel), unnamed: create(:unnamed) } }
  let(:filtered_by_name) { Order.create(user: users[:john_cena], sum: 205.30, ordered_at: "2018-10-08 23:12:24") }
  let(:filtered_by_sum) { Order.create(user: users[:razrushitel], sum: 1000.0, ordered_at: "2023-10-09 02:12:39") }
  let(:filtered_by_date) { Order.create(user: users[:unnamed], sum: 80.55, ordered_at: "2023-10-09 03:12:39") }
  let(:date_params) { { "start_date" => "2017-10-08_23:12:24", "end_date" => "2024-10-09_03:12:39" } }

  before do
    users
    filtered_by_name
    filtered_by_date
    filtered_by_sum
  end

  context "when supplying filter that fits all" do
    it "returns all orders" do
      expect(described_class.call(date_params)).to contain_exactly(filtered_by_date, filtered_by_name, filtered_by_sum)
    end
  end

  context "when filtering by sum" do
    let(:sum_params) { date_params.merge({ "sum" => "1000.0" }) }
    it "returns orders with matching sum" do
      expect(described_class.call(sum_params)).to contain_exactly(filtered_by_sum)
    end
  end

  context "when filtering by name" do
    let(:name_params) { date_params.merge({ "user_name" => "john cena" }) }
    it "returns orders with matching sum" do
      expect(described_class.call(name_params)).to contain_exactly(filtered_by_name)
    end
  end

  context "when filtering by date" do
    let(:date_params) { { "start_date" => "2023-10-09_02:15:30", "end_date" => "2023-10-09_03:20:00" } }
    it "returns orders with matching date" do
      expect(described_class.call(date_params)).to contain_exactly(filtered_by_date)
    end
  end
end

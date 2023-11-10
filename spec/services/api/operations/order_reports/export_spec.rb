# frozen_string_literal: true

RSpec.describe Api::Operations::OrderReports::Export do
  describe "#call" do
    context "when order report not found" do
      it "returns failure" do
        result = subject.call(1)
        expect(result).to be_a(Dry::Monads::Failure)
      end
    end

    context "when order report found" do
      it "returns success" do
        order_report = create(:order_report)
        result = subject.call(order_report.id)
        expect(result).to be_a(Dry::Monads::Success)
        expect(result.value!).to be_a(OrderReport)
        expect(result.value!.status).to eq("complete")
        expect(result.value!.file.current_path).to include("report-")
      end
    end
  end
end

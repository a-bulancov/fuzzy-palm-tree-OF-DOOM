# frozen_string_literal: true


RSpec.describe Api::Operations::OrderReports::Create do
  describe "#call" do
    ActiveJob::Base.queue_adapter = :test

    context "when order report params invalid" do
      it "returns failure" do
        result = subject.call({})
        expect(result).to be_a(Dry::Monads::Failure)
      end
    end

    context "when order report params valid" do
      it "returns success" do
        result = subject.call({user_id_in: [1, 2, 3]})
        expect(result).to be_a(Dry::Monads::Success)
        expect(result.value!).to be_a(OrderReport)
        expect(result.value!.status).to eq("processing")
        expect(result.value!.payload).to include("user_id_in" => [1, 2, 3])
      end

      it "enqueued export job" do
        expect{subject.call({user_id_in: [1, 2, 3]})}.to(
          have_enqueued_job(OrderReportsExportJob)
        )
      end
    end
  end
end

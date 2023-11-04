RSpec.describe FindOrders do
  let(:order) { create(:order) }
  let(:initial_scope) { Order.all }

  let(:params) { {} }

  subject { described_class.new(initial_scope).call(params) }

  context 'with empty params' do
    it 'query forall records' do
      expect(subject.to_sql).to include('SELECT "orders".* FROM "orders"')
    end
  end

  context 'with params' do
    let(:params) { { from_price: 10.0, to_price: 50.0, user_id: 1 } }

    it 'filtered query' do
      expect(subject.to_sql).to include('SELECT "orders".* FROM "orders" WHERE (price <= 50.0) AND "orders"."user_id" = 1')
    end
  end
end

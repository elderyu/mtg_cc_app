require 'rails_helper'

RSpec.describe Card, elasticsearch: true, :type => :model do
  it 'should be indexed' do
     expect(Card.__elasticsearch__.index_exists?).to be_truthy
  end
end

require 'rails_helper'

describe AuthenticationTokenService do
  describe '.call' do
    it 'returns a valid token' do
      expect(described_class.call).to eq('123')
    end
  end
end

require 'rails_helper'

describe AuthenticationTokenService do
  describe '.call' do
    let(:token) { described_class.call }
    it 'returns a valid token' do
      decoded_token = JWT.decode(
        token,
        described_class::HMAC_SECRET,
        true,
        { algorithm: described_class::ALGORITHM_TYPE }
      )
      
      expect(decoded_token).to eq(
        [
          {"data" => "test"},
          {"alg" => 'HS256'}
        ]
      )
    end
  end
end

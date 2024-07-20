require 'rails_helper'

describe 'Authentication', type: :request do
  describe 'POST /authenticate' do
    let(:user) { FactoryBot.create(:user, username: 'User1') }
    it 'authenticates the client' do
      post '/api/v1/authenticate', params: { username: user.username, password: 'password' }

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        'token' => '123'
      )
    end

    it 'returns error when the username is missing' do
      post '/api/v1/authenticate', params: { password: 'password' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        'error' => 'param is missing or the value is empty: username'
      })
    end

    it 'returns error when the password is missing' do
      post '/api/v1/authenticate', params: { username: user.username }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        'error' => 'param is missing or the value is empty: password'
      })
    end
  end
end

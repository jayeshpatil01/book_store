require 'rails_helper'

describe 'Authentication' do
  describe 'POST /autheticate' do
    it 'athenticates the client' do
      post '/api/v1/authenticate'
    end
  end
end

require 'rails_helper'

describe 'Books API', type: :request do
  let(:author1) { FactoryBot.create(:author, first_name: 'George', last_name: 'Orwell', age: 48) }
  let(:author2) { FactoryBot.create(:author, first_name: 'H.G.', last_name: 'Wells', age: 78) }

  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title: '1984', author: author1)
      FactoryBot.create(:book, title: 'The Time machine', author: author2)
    end

    it 'returns all the books' do
      get '/api/v1/books'
  
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body).to include(
        {
          "id" => Book.first.id,
          "title" => '1984',
          "author_name" => 'George Orwell',
          "author_age" => 48
        }
      )
    end

    it 'returns a subset of books base on limit' do
      get '/api/v1/books', params: { limit: 1 }
  
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [{
          "id" => Book.first.id,
          "title" => '1984',
          "author_name" => 'George Orwell',
          "author_age" => 48
        }]
      )
    end

    it 'returns a subset of books based on limit and offset' do
      get '/api/v1/books', params: { limit: 1, offset: 1}

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [{
          "id" => Book.second.id,
          "title" => 'The Time machine',
          "author_name" => 'H.G. Wells',
          "author_age" => 78
        }]
      )
    end
  end

  describe 'POST /books' do
    it 'creats a new book' do
      user = FactoryBot.create(:user, username: 'test1', password: 'test1')
      expect {
          post '/api/v1/books', params: {
            book: {title: 'The Martian'},
            author: {first_name: 'Andy', last_name: 'Weir', age: '48'}
    }, headers: { "Authorization" => "Bearer #{AuthenticationTokenService.call(user.id)}" }
      }.to change { Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(response_body).to eq(
        {
          "id" => Book.first.id,
          "title" => 'The Martian',
          "author_name" => 'Andy Weir',
          "author_age" => 48
        }
      )
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) { FactoryBot.create(:book, title: '1984', author: author1) }
    it 'deletes a book' do
      expect {
          delete "/api/v1/books/#{book.id}"
      }.to change {Book.count}.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end

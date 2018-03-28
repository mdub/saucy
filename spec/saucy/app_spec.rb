require 'spec_helper'

require 'rack/test'
require 'saucy/app'

describe 'app' do

  include Rack::Test::Methods

  let(:app) { Sinatra::Application }

  describe 'GET /' do
    it 'says hello' do
      get '/'
      expect(last_response.body).to eq("Hello world!")
    end
  end

  describe 'GET /numbers' do
    it 'returns numbers' do
      get '/numbers?max=3'
      expect(last_response.body).to include(%({"count":1}))
    end
  end

end

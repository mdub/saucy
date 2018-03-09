require 'sinatra'

class Clock
  def each
    loop do
      yield "#{Time.now}\n"
      sleep 1
    end
  end
end

get('/clock') do
  content_type :json
  Clock.new
end

get '/' do
  'Hello world!'
end

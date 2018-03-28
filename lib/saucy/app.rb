require 'json'
require 'sinatra'

get '/' do
  "Hello world!\n"
end

class Numbers

  def initialize(max)
    @max = max
  end

  def each
    1.upto(@max) do |i|
      data = {
        count: i
      }
      yield data
    end
  end

end

class JsonSequence # RFC-7464

  RS = "\x1E"

  def initialize(source)
    @source = source
  end

  def each
    @source.each do |data|
      yield "\n#{RS}#{JSON.dump(data)}\n"
    end
  end

end

class SlowStream

  def initialize(source, delay)
    @source = source
    @delay = Float(delay)
  end

  attr_reader :source
  attr_reader :delay

  def each
    source.each do |item|
      yield item
      sleep delay
    end
  end

end

get('/numbers') do
  content_type :json
  max = Integer(params.fetch(:max, 100))
  stream = Numbers.new(max)
  if delay = params[:delay]
    stream = SlowStream.new(stream, delay)
  end
  JsonSequence.new(stream)
end

require 'sinatra'
require 'oauth'
require 'json'

OAUTH_CONSUMER = OAuth::Consumer.new(
  ENV['TWITTER_CONSUMER_KEY'],
  ENV['TWITTER_CONSUMER_SECRET'],
  :site => 'http://api.twitter.com'
)

OAUTH_TOKEN = OAuth::AccessToken.new(
  OAUTH_CONSUMER,
  ENV['TWITTER_ACCESS_TOKEN'],
  ENV['TWITTER_ACCESS_SECRET']
)

ENDPOINT = [
  "/1.1/search/tweets.json?q=#{CGI.escape(ENV['TWITTER_SEARCH_TERM'])}",
  "result_type=recent",
  "count=50"
].join("&")

get '/' do
  erb :index
end

get '/tweet_ids' do
  response = OAUTH_TOKEN.get(ENDPOINT)
  case response.code
  when "200"
    if statuses = JSON.parse(response.body)['statuses']
      statuses.map do |status|
        status['retweeted_status'] ? nil : status['id_str']
      end.compact.to_json
    else
      "[]"
    end
  else
    "[]"
  end
end

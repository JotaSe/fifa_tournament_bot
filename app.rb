require 'sinatra'
require 'mechanize'
require 'json'

post '/gateway' do
  message = params[:text].gsub(params[:trigger_word], '').strip
  puts params
  puts message
  action, repo = message.split('_').map { |c| c.strip.downcase }

  case action
  when 'table' then table
  when 'leader' then leader
  when 'test' then test
  end
end

def respond_message(message)
  content_type :json
  { text: message }.to_json
end

def table
  page = table_page
  page.search('.//table').first.search
end

def table_page
  @agent ||= Mechanize.new
  @agent.get 'http://www.fifagenerator.com/tournament/47617/table/'
end

def test
  respond_message 'test'
end

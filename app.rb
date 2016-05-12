require 'sinatra'
require 'mechanize'
require 'json'

post '/gateway' do
  action = params[:text].gsub(params[:trigger_word], '').strip
  case action
  when 'tabla' then table
  when 'lider' then leader
  end
end

def respond_message(message)
  content_type :json
  { text: message }.to_json
end

def get_table
  page = table_page
  table = page.search('.//table').first
  headers = table.search('.//th').map { |th| th.text.squish }.to_s + "\n"
  trs = table.search('.//tbody//tr')
  rows = trs.map do |tr|
    tr.search('.//td').map { |td| td.text.squish }.to_s + "\n"
  end
  message = "#{headers}\n#{rows}"
  respond_message message
end

def table_page
  @agent ||= Mechanize.new
  @agent.get 'http://www.fifagenerator.com/tournament/47617/table/'
end

def test(params, message)
  respond_message "params: #{params} | message: #{message}"
end

require 'sinatra'
require 'mechanize'
require 'json'

get '/' do
  "Hello World"
end

post '/gateway' do
  if !params[:text].nil?
    action = params[:text].gsub(params[:trigger_word], '').strip
    case action
    when 'tabla' then table
    when 'lider' then leader
    else respond_message 'Accion desconocida'
    end
  else
    respond_message 'Escriba una opcion [tabla, lider]'
  end
end

def respond_message(message)
  content_type :json
  { text: message,
    username: 'MundialitoBot' }.to_json
end

def table
  page = table_page
  table = page.search('.//table').first
  headers = table.search('.//th').map { |th| clean(th.text) }.to_s + "\n"
  trs = table.search('.//tbody//tr')
  rows = trs.map do |tr|
    tr.search('.//td').map { |td| clean(td.text) }.to_s + "\n"
  end
  message = "#{headers}\n#{rows}"
  respond_message message
end

def clean(text)
  text.delete('"').delete('\\')
end

def table_page
  @agent ||= Mechanize.new
  @agent.get 'http://www.fifagenerator.com/tournament/47617/table/'
end

def test(params, message)
  respond_message "params: #{params} | message: #{message}"
end

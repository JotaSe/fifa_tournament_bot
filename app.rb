require 'sinatra'
require 'mechanize'
require 'json'

get '/' do
  'Hello World'
end

post '/gateway' do
  if !params[:text].nil?
    action = params.key?('trigger_word') ? params[:text].gsub(params[:trigger_word], '').strip : params[:text]
    case action
    when 'tabla' then table
    when 'lider' then leader
    when 'reglas' then rules
    when 'weon malo' then loser
    when 'test' then mrkdwn_test
    else respond_message 'Accion desconocida'
    end
  else
    respond_message 'Escriba una opcion [tabla, lider]'
  end
end

def respond_message(message)
  content_type :json
  { text: message,
    username: 'MundialitoBot',
    mrkdwn: true }.to_json
end

def table
  get_table 'team'
  message = ([@headers] + @rows).map { |r| r.join ', ' }.join "\n"
  respond_message message
end

def get_table(type)
  page = table_page
  table = page.search('.//table')
  table = type == 'team' ? table.first : table.last
  @headers = table.search('.//th').map(&:text)
  trs = table.search('.//tbody//tr')
  @rows = trs.map do |tr|
    tr.search('.//td').map(&:text)
  end
end

def table_page
  @agent ||= Mechanize.new
  @agent.get 'http://www.fifagenerator.com/tournament/47617/table/'
end

def leader
  get_table 'player'
  respond_message "El lider de la tabla es #{@rows.first[1]} con #{@rows.first[9]} puntos"
end

def loser
  get_table 'player'
  respond_message "Es MAS MALO DEL MUNDIALITO DEL MUNDO MUNDIAL ES #{@rows.last[1]} con #{@rows.last[9]} puntos WEON MALO"
end

def test(params, message)
  respond_message "params: #{params} | message: #{message}"
end

def rules
  _rules = '1. Partidos de 5 Minutos',
           '2. Todos contra todos',
           '3. Ida y vuelta',
           '4. Clasifican los primeros 4',
           '5. Partidos a las 13:00 hrs y 19:00 (en adelante)',
           '6. Se respeta el orden del fixture (de no poder uno, se corre al siguiente partido)',
           '7. Los 2 últimos pagan las pizzas de la final',
           '8. Los 3 primeros lugares reciben (30.00 - 15.000 y 5.000 respectivamente)',
           '9. Se pide respeto del público presente, juego limpio',
           '10. Están permitidos los bombos, los lienzos, el fuego de artificio y porristas.'
  message =  _rules.join "\n"
  respond_message message
end

def mrkdwn_test
  text = 'tables|are|cool',
         '---|---|---',
         '1|2|3',
         '4|5|6',
         '7|8|9'
  respond_message text.join "\n"
end

def set_tournament(id)
  @@tournament_id = id
end
require 'telegram/bot'
require 'watir'
if !File.exist? "#{__dir__}/.config"
    puts 'Inserisci token del bot:'
    print '> '
    token = gets.chomp
    puts "Inserisci nome del file contenente i biglietti (serie e numero devono essere separati da uno spazio):"
    print '> '
    filename = gets.chomp
    puts "Inserisci chat_id del destinatario:"
    print '> '
    chat_id = gets.chomp
    File.open("#{__dir__}/.config", "w") do |file| 
      file.puts token
      file.puts filename
      file.puts chat_id
    end
  end  
userdata = File.open("#{__dir__}/.config", "r").to_a

userdata.map { |e| e.strip! }

biglietti = File.open("#{__dir__}/#{userdata[1]}", "r").to_a

b = Watir::Browser.new :firefox, headless: true
b.goto("https://ldt.lottomaticaitalia.it/showcase/?idRivenditore=ltmita&kind=web&config=verifica")

biglietti_perdenti = []
biglietti_vincenti = []

biglietti.each do |biglietto|
  serie = b.text_field(name: "serie")
  serie.set biglietto.split(" ")[0]

  numero = b.text_field(name: "numero")
  numero.set biglietto.split(" ")[1]

  verifica = b.button(class: "action")
  verifica.click

  classes =  b.div(id: "verifier").classes

  if classes.include?("won")
    puts "Complimenti! #{biglietto.gsub("\n", "")} vincente!"
    biglietti_vincenti.push(biglietto)
  else 
    puts "#{biglietto.gsub("\n", "")} non vincente :("
    biglietti_perdenti.push(biglietto)
  end

  b.a(class: "close").click
end

Telegram::Bot::Client.run(userdata[0]) do |bot|
    if biglietti_vincenti.any?
        bot.api.send_message(chat_id: userdata[2], text: "Complimenti! Hai vinto il premio dei Soliti Ignoti con #{biglietti_vincenti.map { |b| b.gsub("\n", "")}}. Hai inoltre #{biglietti_perdenti.count} biglietti perdenti.")
    else
      bot.api.send_message(chat_id: userdata[2], text: "Mi dispiace ma non hai vinto nessuno dei premi dei Soliti Ignoti, hai #{biglietti_perdenti.count} biglietti perdenti.")
    end
end
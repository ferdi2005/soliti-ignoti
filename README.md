# Soliti ignoti
Controlla automaticamente se il tuo biglietto della Lotteria Italia (2020) è vincente o no ai soliti ignoti, ricevendo un messaggio da un bot Telegram.
## Dipendenze
Per eseguire questo script è necessario avere la gem Ruby Watir, installabile con `gem install watir`, Firefox e il suo Webdriver (ulteriori informazioni sull'installazione [qui](http://watir.com/guides/firefox/)).
## Configurazione
Lo script chiede al primo avvio i parametri di configurazione necessari, salvandoli. È necessario creare un bot Telegram con [@botfather](https://t.me/botfather) e recuperarne il token, inoltre è importante mettere i biglietti in un file di testo e separare il numero di serie dal numero del biglietto con uno spazio.
## Eseguire ciclicamente
Potete aggiungere lo script alla crontab, chiedendo `which ruby` ed inserendo in crontab una cosa del genere (sostituendo user col nome del vostro utente, /usr/bin/ruby col risultato di which ruby e directory col path allo script):
```
0 1 * * * user /usr/bin/ruby /directory/biglietti.rb
```
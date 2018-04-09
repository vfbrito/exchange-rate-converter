Exchange rate converter
======

Sinatra modular app to convert USD on EUR amounts based on ECB rates.

Setup with Docker:

* Run the app: **$ docker-compose up**

* Rake task to download and update ECB rates: **$ docker-compose run app rake eur_rates:update**

* Run the tests: **$ docker-compose run app rspec spec**

README
=======

* Ruby version: 2.0.0
* Rails version: 4.0.0.rc2

Configuration
--------------

    bundle install --path vendor/bundle
    cp .env.tmpl .env
    # and edit .env

Database initialization
-----------------------

    bundle exec rake db:migrate
    bundle exec rake walk88:map:import

Create direction data

    bundle exec rake walk88:map:direction:create

Calculate distance info from direction data

    bundle exec rake walk88:map:direction:distance


Memo
------

    bundle exec rake assets:precompile
    bundle exec rails server -p 2000 -e production

Batch系コマンド
-----------------

### Fitbitサーバからデータを取得する
    TZ=Japan bundle exec rails runner -e production FitbitImport.execute

### ユーザのPin画像を再取得する
    TZ=Japan bundle exec rails runner -e production UserPinUpdate.execute


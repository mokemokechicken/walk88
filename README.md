README
=======

* Ruby version: 2.0.0
* Rails version: 4.0.0.rc2

Configuration
--------------

    bundle install --path vendor/bundle
    bin/decrypt      # for decrypt secrets.json


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

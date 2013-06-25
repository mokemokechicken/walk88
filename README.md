README
=======

* Ruby version: 2.0.0
* Rails version: 4.0.0.rc2

Configuration
--------------

    bundle install --path vendor/bundle


Database initialization
-----------------------

    bundle exec rake db:migrate
    bundle exec rails runner 'Import88Data.execute'

Memo
------

    bundle exec rake assets:precompile
    bundle exec rails server -p 2000 -e production



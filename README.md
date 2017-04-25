### README

##### API
  ```bash
    rake docs:generate RAILS_ENV=test
  ```
  Will generate API docs in `public/docs/api/all/index.html` with detailed information on reqests/responces

##### Ruby version.
  - 2.4.0

##### System dependencies.
  - postgresql 9.6.2
    enable_extension "plpgsql"
    enable_extension "citext"
    enable_extension "pgcrypto"
    enable_extension "postgis"
    enable_extension "hstore"

##### Configuration
  ```dotenv-rails``` gem used.
  More info on how it works:
  http://devblog.avdi.org/2014/01/17/dotenv-for-multiple-environments/#comments-title

##### Database creation/initialization

  ```bash
    rake db:drop && rake db:create && rake db:migrate && rake db:seed
    rake db:drop RAILS_ENV=test && rake db:create RAILS_ENV=test && rake db:migrate RAILS_ENV=test
  ```
  Will reset the current db with test data.

  In case of errors 'Error reading triggers in...' see ```config/initializers/ruby_parser_overrides.rb```
  to override parser for curent ruby version

##### Start web server on developer's computer

  ```bash
    cp .env.test.sample .env.test
    cp .env.development.sample .env.development
    cp .env.staging.sample .env.staging
    cp .env.sample .env
  ```
  For local testing need add to /etc/hosts

  ```bash
    127.0.0.1       api.lavo.dev
    127.0.0.1       lavo.dev
  ```

##### Testing from rails console
  ```bash
    rails console
  ```
  ```ruby
    > Customer.first.activated?
    > true
    > Customer.last.activated?
    > false
  ```
  Customer with email "customer-1@example.com" is activated.
  Customer with email "customer-2@example.com" isn't active.

  See db/seeds.rb for details.

##### Testing with curl
  ```bash
   curl "http://api.lavo.devlits.com/signin" -d '{"data":{"type":"signin","attributes":{"email":"customer-1@example.com","password":"123456"}}}' -X POST -H "Content-Type: application/vnd.api+json; charset=utf-8" -H "Accept: application/vnd.api+json" -H "X-API-Version: api.v1"
  ```
  Response:
  ```bash
  {"data":{"id":"1","type":"customers","attributes":{"name":null,"surname":null,"email":"customer-1@example.com","avatar":{"url":null},"activated":true},"relationships":{"http-token":{"data":{"id":"1","type":"http-tokens"}}}},"included":[{"id":"1","type":"http-tokens","attributes":{"key":"86c7604e7abd4b159f971ba6c02a8bad","created-at":"2016-05-24T22:38:34.006Z"}}]}
  ```

##### How to run the test suite
  ```bash
    rake docs:generate RAILS_ENV=test
  ```
##### Services (job queues, cache servers, search engines, etc.)
  sidekiq as active job adapter + redis

##### Deployment instructions
  ```bash
    git push origin production
    git push origin staging
  ```

##### I18n
  The app should be prepared for I18n. See config/locales/*.* for examples.


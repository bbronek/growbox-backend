# Main growbox backend
[![Ruby](https://img.shields.io/badge/ruby-3.2.0-brightgreen.svg)](https://www.ruby-lang.org/en/news/2022/12/25/ruby-3-2-0-released/)
[![Rails](https://img.shields.io/badge/rails-7.0.4-brightgreen.svg)](https://rubygems.org/gems/rails/versions/7.0.4)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)

<!-- TABLE OF CONTENTS -->
## Table of Contents
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Development](#development)
* [Test](#test)
* [PostgreSQL](#postgresql)

<!-- GETTING STARTED -->
## Getting Started
To get a local copy up and running follow these simple example steps.

<!-- PREREQUISITES -->
### Prerequisites
- **Ruby & Postgresql**
  - https://www.ruby-lang.org/
  - https://www.postgresql.org/

<!-- INSTALLATION -->
##### Installation
1. Clone the repo

###### HTTPS

```sh
git clone https://github.com/growboxers/growbox-backend.git 
```

###### SSH

```sh
git clone git@github.com:growboxers/growbox-backend.git
```

2. Install dependencies
```sh
bundle install
```
3. Create DB
```sh
rails db:setup
```
4. Add required environments in `app/.env`
```sh
DB_LOCAL_PASSWORD=
```

<!-- DEVELOPMENT -->
## Development
List of usefull commands
1. Boot application
```sh
rails s
```
2. Manually run standardrb
```sh
bundle exec standardrb
```
3. Run migrations
```sh
rails db:migrate
```
4. Populate database
```sh
rails db:seed
rails db:seed:replant
```

<!-- TEST -->
## Test
List of usefull commands
1. Run all specs
```sh
bundle exec rspec
```

<!-- POSTGRESQL -->
## PostgreSQL
1. Create superuser test
```sh
CREATE USER test SUPERUSER;
```
2. (Optional) Set up password
  - first option
  
```sh
CREATE USER test WITH PASSWORD 'test' SUPERUSER;
```

  - second option (after creating user without password)

```sh
ALTER USER test WITH PASSWORD 'test';
```



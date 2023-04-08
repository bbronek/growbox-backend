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
* [Docker](#docker)
* [License](#license)

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
3. Create DB (make sure that you did PostgreSQL section before)
```sh
rails db:setup
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
2. (Required) Set up password
  - first option
  
```sh
CREATE USER test WITH PASSWORD 'test' SUPERUSER;
```

  - second option (after creating user without password)

```sh
ALTER USER test WITH PASSWORD 'test';
```
<!-- DOCKER -->

## Docker

### Prerequisites 
 - [Docker](https://docs.docker.com/get-docker/)
 - [Docker Compose](https://docs.docker.com/compose/install/)

1. Clone the repo

###### HTTPS

```sh
git clone https://github.com/growboxers/growbox-backend.git 
```

###### SSH

```sh
git clone git@github.com:growboxers/growbox-backend.git
```

2. Build the Docker images and start the containers

```sh
cd growbox-backend
docker compose up --build
```

This command will start two containers: one for the database and one for the web application.

#### Accessing the app

The app wil be accessible at `https://localhost:3000`

#### Stopping the app

```sh
docker compose down
```

#### Configuration
##### Environment Variables
The following environment variables can be set in the docker-compose.yml file:

    POSTGRES_USER: the username for the database (default: test)
    POSTGRES_PASSWORD: the password for the database (default: test)
    POSTGRES_DB: the name of the development database (default: growbox_backend_development)
    DATABASE_USER: the username for the application to connect to the database (default: test)
    DATABASE_PASSWORD: the password for the application to connect to the database (default: test)
    DATABASE_NAME: the name of the development database (default: growbox_backend_development)
    DATABASE_HOST: the hostname of the database container (default: db)
    DATABASE_PORT: the port number for the database (default: 5432)

#### Volumes

The following volumes are used in `docker-compose.yml` file:

`./db/init.sql:/docker-entrypoint-initdb.d/init.sql`: this volume is used to initialize the database with a script named `init.sql.`

#### Troubleshooting

If you have any issues with the app, try the following:

  - Check the logs of the containers using the `docker compose logs` command.
  - Make sure that the required ports are open and accessible
  - Check the configuration of the containers and the environment variables

<!-- License -->

## License

This project is licensed under the BSD-2-Clause license - see the `LICENSE.md` file for details.

# blind-test-api

[![Amber Framework](https://img.shields.io/badge/using-amber_framework-orange.svg)](https://amberframework.org)

This is a project written using [Amber](https://amberframework.org). Enjoy!

## Prerequisites

- crystal 0.28.0
- amber
- postgresql

## Getting Started

- Clone this repository
- Duplicate the `.env.sample` file to `.env` and ask the others devs for the env variables.

A - Installing crystal
- Install crystal 0.28.0 using `crenv`
- [Intall amber](https://docs.amberframework.org/amber/getting-started)
- Run `shards install` to install dependencies
- Run `amber db create migrate` to setup the database
- Run `amber w` to start the server
- Run `crystal spec` to run the specs
- Run `crystal tool format` to run the linter

B - Using Docker
- Run `docker-compose build` to setup
- Run `docker-compose up` to start the server
- Run `docker-compose run specs` to run the specs

Now you can target http://localhost:3000/ with curl and postman.

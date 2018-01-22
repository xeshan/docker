postgres
========

Launch Postgres server:

    $ docker-compose up

Get mapped Postgres port for the primary:

    $ docker-compose port primary 5432
    0.0.0.0:32772

Connect to the database:

    $ psql -h localhost -p 32772 -U postgres postgres
    Password for user postgres:
    psql (9.4.10, server 9.6.1)
    WARNING: psql major version 9.4, server major version 9.6.

    postgres=#


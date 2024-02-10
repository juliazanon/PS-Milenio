# rm_api

Small API that stores travel plans, based on locations on the [Rick and Morty API](https://rickandmortyapi.com/)

## Installation

Make sure there is no process running on port 5432
- If volumes are not loaded (ex: project cloned/downloaded from github):
You need to load the migrations:
```
docker-compose build
```
```
docker-compose up
```
While the containers are running:
```
docker exec ps-milenio_kemal_1 make sam db:migrate
```

API is then ready to work with

- If volumes are already loaded
```
docker-compose build
```
```
docker-compose up
```

If you get an error on pg_dump like the following, just run docker-compose down, then up again, and repeat the commands
```
pg_dump: error: server version: 16.1 (Debian 16.1-1.pgdg120+1); pg_dump version: 14.10 (Ubuntu 14.10-0ubuntu0.22.04.1)
pg_dump: error: aborting because of server version mismatch
```
## Usage

#### To run the application:
```
docker-compose up
```
#### Send requests to 'localhost:3000':
- get '/travel_plans'
- get '/travel_plans/:id'
- post '/travel_plans'

body:
```
{
    "travel_stops": [1,2,3]
}
```
- put '/travel_plans/:id'

body:
```
{
    "travel_stops": [1,2,3]
}
```
- delete '/travel_stops/:id'

Get requests also accept query parameters: 'optimize' and 'expand'

#### After closing the application, remember to run:
```
docker-compose down
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/juliazanon/rm_api/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Julia](https://github.com/juliazanon) - creator and maintainer

# ServerTrack

This Rails application contains two endpoints:
* GET http://localhost:3000/records/server_id
A get request to this endpoint will return averages for CPU and RAM usage for the last hour broken down into minutes, and the last 24 hours broken down by hour.

* POST http://localhost:3000/records
This endpoint takes a post request that contains the following information: {
    "cpu": "33.4",
    "ram": "55.1",
    "server_id": "Edward"
}
cpu is the CPU average for a server. Value is a float.
ram is the RAM average for a server. Value is a float.
server_id is the name of the server. Value is a string.


Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# ServerTrack

This Rails application contains two endpoints:
* GET http://localhost:3000/records/server_id

A get request to this endpoint will return averages for CPU and RAM usage for the

last hour broken down into minutes, and the last 24 hours broken down by hour.

* POST http://localhost:3000/records

This endpoint takes a post request that contains the following information:

* cpu is the CPU average for a server. Value is a float.

* ram is the RAM average for a server. Value is a float.

* server_id is the name of the server. Value is a string.

To start the server:

Navigate into the ServerTrack folder

Type the words:

rails server

into the command line

To use cURL:

curl -d "cpu=3.4&ram=5.6&server_id=Edward" "http://localhost:3000/records"

To use Postman:

Structure for information in body of request:

{

    "cpu": "33.4",

    "ram": "55.1",

    "server_id": "Edward"
}

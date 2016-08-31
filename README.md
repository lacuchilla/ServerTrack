# ServerTrack

How to use ServerTrack:

Ruby on Rails and the bundler gem are required to use this project

docs.railsbridge.org/installfest has a great tutorial for getting set up with Rails

Make sure you type gem install bundler and then bundle install into the terminal to install all required gems

In your web browser, navigate to
https://github.com/lacuchilla/ServerTrack

Click on the clone or download button

Click on the copy to clipboard icon

Using the terminal, navigate to where you want the ServerTrack project to live and create an empty folder

Navigate into the empty folder and type:
git clone

then paste the copied information

Hit enter

Navigate into the project folder
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

Open another terminal tab

To use cURL:

curl -d "cpu=3.4&ram=5.6&server_id=Edward" "http://localhost:3000/records"

To use Postman:

download the operating system app or google app

Structure for information in body of request:

{

    "cpu": "33.4",

    "ram": "55.1",

    "server_id": "Edward"
}

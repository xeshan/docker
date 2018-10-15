# Docker with Apache Ubuntu and PHP

<h1>Setting up the project</h1>
<ul>
<li>./Dockerfile </li>
<li>./app/index.php</li>
<li>./apache-config.conf</li>
</ul>

<h1>Building the container</h1>
docker build -t app .

<h1>Running the container</h1>
docker run -d -p 80:80 -v /data/server/app:/var/www/html/app --name app app

Note: /data/server/app is your local drive wich maping to continer directory and changes in that directory reflect on your app. change /data/server/app accordingly
<h1>Logging into the container</h1>
docker exec -it app /bin/bash

<h1>Stop/Remove the container</h1>
docker stop app
docker rm app

<h1>Volume logs of container to host</h1>
docker run -d -p 80:80 -v /data/server/app:/var/www/site/app -v /data/server/log:/var/log/apache2 --name app app 


### Starting a MySQL Server Instance

Start a new Docker container for the MySQL Community Server with this command:

    docker run --name=mysql -d mysql/mysql-server:tag
                 
             

The `--name` option, for supplying a custom name for your server container (`mysql` in the example), is optional; if no container name is supplied, a random one is generated. If the Docker image of the specified name and tag has not been downloaded by an earlier `docker pull` or `docker run` command, the image is now downloaded. After download completes, initialization for the container begins, and the container appears in the list of running containers when you run the `docker ps` command; for example:

    shell> docker ps
    CONTAINER ID   IMAGE                COMMAND                  CREATED             STATUS                              PORTS                NAMES
    a24888f0d6f4   mysql/mysql-server   "/entrypoint.sh my..."   14 seconds ago      Up 13 seconds (health: starting)    3306/tcp, 33060/tcp  mysql 

The container initialization might take some time. When the server is ready for use, the `STATUS` of the container in the output of the `docker ps` command changes from `(health: starting)` to `(healthy)`.

The `-d` option used in the `docker
        run` command above makes the container run in the background. Use this command to monitor the output from the container:

       docker logs mysql
                

Once initialization is finished, the command's output is going to contain the random password generated for the root user; check the password with, for example, this command:

    shell> docker logs mysql 2>&1 | grep GENERATED
    GENERATED ROOT PASSWORD: Axegh3kAJyDLaRuBemecis&EShOs

### Connecting to MySQL Server from within the Container

Once the server is ready, you can run the `mysql` client within the MySQL Server container you just started and connect it to the MySQL Server. Use the `docker exec -it` command to start a `mysql` client inside the Docker container you have started, like this:

       docker exec -it mysql mysql -uroot -p
                

When asked, enter the generated root password (see the instructions above on how to find it). Because the `MYSQL_ONETIME_PASSWORD` option is true by default, after you started the server container with the sample command above and connected a `mysql` client to the server, you must reset the server root password by issuing this statement:

    mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
                

Substitute `newpassword` with the password of your choice. Once the password is reset, the server is ready for use.

### Container Shell Access

To have shell access to your MySQL Server container, use the `docker exec -it` command to start a bash shell inside the container:

    shell> docker exec -it mysql bash 
    bash-4.2#    

You can then run Linux commands inside the container at the bash prompt.

### Stopping and Deleting a MySQL Container

To stop the MySQL Server container we have created, use this command:

    docker stop mysql
             

`docker stop` sends a SIGTERM signal to the `mysqld` process, so that the server is shut down gracefully.

Also notice that when the main process of a container (`mysqld` in the case of a MySQL Server container) is stopped, the Docker container stops automatically.

To start the MySQL Server container again:

    docker start mysql
             

To stop and start again the MySQL Server container with a single command:

    docker restart mysql
             

To delete the MySQL container, stop it first, and then use the `docker rm` command:

    docker stop mysql
             
    docker rm mysql 
             

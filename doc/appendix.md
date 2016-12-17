\appendix

Függelék
========

##Dockerfile-ok\label{appendix-dockerfile}

###Autentikáció

Dockerfile.auth.service

```{Dockerfile}
FROM ubuntu
MAINTAINER Borlay Dániel <borlay.daniel@gmail.com>

ENV CONSUL_DIR /usr/share/consul

# Install Service
COPY auth-service.py /usr/sbin/auth-service.py
RUN apt-get -y update && \
    apt-get -y install \
        bash \
        iputils-ping \
        python-oauth \
        python-mysqldb \
        python \
        python-flask && \
    chmod +x /usr/sbin/auth-service.py

# Install consul
COPY consul consul-template /usr/bin/
RUN chmod +x /usr/bin/consul && \
    chmod +x /usr/bin/consul-template && \
    mkdir -p /etc/consul.d
COPY auth.json /etc/consul.d/auth.json

# Install entry point
COPY init /usr/sbin/init-auth
RUN chmod +x /usr/sbin/init-auth

ENTRYPOINT /bin/bash /usr/sbin/init-auth

EXPOSE 8081 8301 8302 8500 8400
```

###Proxy

Dockerfile.proxy.service

```{Dockerfile}
FROM haproxy
MAINTAINER Borlay Dániel <borlay.daniel@gmail.com>

ENV CONSUL_DIR /usr/share/consul

# Install Service
COPY proxy.sh /usr/sbin/proxy.sh
RUN apt-get -y update && \
    apt-get -y --force-yes install haproxy iputils-ping && \
    chmod +x /usr/sbin/proxy.sh
COPY haproxy.cfg /etc/haproxy/haproxy.cfg

# Install consul
COPY consul consul-template /usr/bin/
RUN mkdir -p /etc/consul.d && \
    chmod +x /usr/bin/consul && \
    chmod +x /usr/bin/consul-template
COPY proxy.json /etc/consul.d/proxy.json

# Install entry point
COPY init /usr/sbin/init-proxy
RUN chmod +x /usr/sbin/init-proxy

ENTRYPOINT /bin/bash /usr/sbin/init-proxy

EXPOSE 8080 8301 8302 8500 8400
```

###Adatbázis

Dockerfile.database.service

```{Dockerfile}
FROM ubuntu
MAINTAINER Borlay Dániel <borlay.daniel@gmail.com>

USER root
ENV CONSUL_DIR /usr/share/consul

# Install Service
COPY database.sh /usr/sbin/database.sh
COPY auth_init.sql bookstore_init.sql /tmp/
RUN apt-get -y update && \
    /bin/bash -c "debconf-set-selections \
<<< 'mysql-server mysql-server/root_password password root'" && \
    /bin/bash -c "debconf-set-selections \
<<< 'mysql-server mysql-server/root_password_again password root'" && \
    apt-get -y install mysql-server \
        iputils-ping \
        mysql-client && \
    chmod +x /usr/sbin/database.sh

# Install consul
COPY consul consul-template /usr/bin/
RUN mkdir -p /etc/consul.d && \
    chmod +x /usr/bin/consul && \
    chmod +x /usr/bin/consul-template
COPY database.json /etc/consul.d/database.json

# Install entry point
COPY init /usr/sbin/init-db
RUN chmod +x /usr/sbin/init-db && \
    sed -i 's/bind-address.*=.*/bind-address = 0.0.0.0/g' \
        /etc/mysql/mysql.conf.d/mysqld.cnf

ENTRYPOINT /bin/bash /usr/sbin/init-db

EXPOSE 3306 8301 8302 8500 8400
```

###Vásárlás

Dockerfile.order.service

```{Dockerfile}
FROM tomcat
MAINTAINER Borlay Dániel <borlay.daniel@gmail.com>

ENV CONSUL_DIR /usr/share/consul

# Install Service
RUN sed -i 's/8080/8888/g' /usr/local/tomcat/conf/server.xml && \
    sed -i 's/<Connector /<Connector address="0.0.0.0" \
        /g' /usr/local/tomcat/conf/server.xml
COPY target/ReserveRESTJerseyExample-0.0.2-SNAPSHOT.war \
    /usr/local/tomcat/webapps/order.war

# Install consul
COPY consul consul-template /usr/bin/
RUN mkdir -p /etc/consul.d && \
    chmod +x /usr/bin/consul && \
    chmod +x /usr/bin/consul-template
COPY order.json /etc/consul.d/order.json

# Install entry point
COPY init /usr/local/sbin/init-order
RUN chmod +x /usr/local/sbin/init-order

ENTRYPOINT /bin/bash /usr/local/sbin/init-order

EXPOSE 8888 8301 8302 8500 8400
```

###Webkiszolgáló (böngészés)

Dockerfile.web.service

```{Dockerfile}
FROM ubuntu
MAINTAINER Borlay Dániel <borlay.daniel@gmail.com>

ENV CONSUL_DIR /usr/share/consul

# Install Service
COPY webserver.sh /usr/sbin/webserver.sh
RUN apt-get -y update && \
    apt-get -y install apache2 php \
        libapache2-mod-php \
        php-mysql \
        curl \
        iputils-ping \
        php-curl && \
    chmod +x /usr/sbin/webserver.sh
COPY index.html main.css login.php store.php order.php /var/www/html/

# Install consul
COPY consul consul-template /usr/bin/
RUN mkdir -p /etc/consul.d && \
    chmod +x /usr/bin/consul && \
    chmod +x /usr/bin/consul-template
COPY web.json /etc/consul.d/web.json

# Install entry point
COPY init /usr/sbin/init-web
RUN chmod +x /usr/sbin/init-web

ENTRYPOINT /bin/bash /usr/sbin/init-web

EXPOSE 80 443 8301 8302 8500 8400
```

##Szkriptek

###Futtatáshoz

####Fordítás\label{appendix-build}

build_{service}.sh

```{bash}
#!/bin/bash

<SERVICE>_SERVICE_HOME=services/<SERVICE>
<SERVICE>_SERVICE_DOCKERFILE=Dockerfiles/Dockerfile.<SERVICE>.service
<SERVICE>_SCRIPT_DIR=scripts/<SERVICE>
<SERVICE>_CONF_DIR=conf/<SERVICE>
<SERVICE>_IMAGE_NAME=bookstore_<SERVICE>

CONSUL_BASE=https://releases.hashicorp.com
CON_VER=0.7.0/consul_0.7.0_linux_386.zip
CONSUL_URL=${CONSUL_BASE}/consul/${CON_VER}
TEMP_VER=0.16.0/consul-template_0.16.0_linux_386.zip
CONSULT_URL=${CONSUL_BASE}/consul-template/${TEMP_VER}

pushd ..
if [[ ! -e consul ]]; then
    echo "Get Consul script from Internet"
    wget ${CONSUL_URL} && unzip consul_0.7.0_linux_386.zip
fi

if [[ ! -e consul-template ]]; then
    echo "Get consul-template script from Internet"
    wget ${CONSULT_URL} && unzip consul-template_0.16.0_linux_386.zip
fi

echo "Create <SERVICE> service for bookstore ..."
echo " - Create directory for Docker data"
mkdir -p ${<SERVICE>_SERVICE_HOME}
echo " - Move Dockerfile to data directory"
cp ${<SERVICE>_SERVICE_DOCKERFILE} ${<SERVICE>_SERVICE_HOME}/Dockerfile
echo " - Move script files to data directory"
cp -R ${<SERVICE>_SCRIPT_DIR}/* ${<SERVICE>_SERVICE_HOME}/
echo " - Move config files to data directory"
cp -R ${<SERVICE>_CONF_DIR}/* ${<SERVICE>_SERVICE_HOME}/
echo " - Move consul to data directory"
cp consul ${<SERVICE>_SERVICE_HOME}/
cp consul-template ${<SERVICE>_SERVICE_HOME}/
echo " - Building Docker image"
docker build -t ${<SERVICE>_IMAGE_NAME} \
    ${<SERVICE>_SERVICE_HOME} &> ${<SERVICE>_SERVICE_HOME}/build.log
echo " - Save image"
docker save \
    --output ${<SERVICE>_SERVICE_HOME}/${<SERVICE>_IMAGE_NAME}.img \
    ${DATABASE_IMAGE_NAME}

echo "<SERVICE> service has been created!"
popd
```

####Futtatás\label{appendix-runner}

run_containers.sh

```{bash}
#!/bin/bash

services="database webserver order auth proxy"

docker network create bookstore

for service in ${services}
do
    echo "Start ${service} service ..."
    docker run -d --name "${service}" \
               -h "${service}" \
              --net=bookstore bookstore_${service}
done
```

####Tisztogatás\label{appendix-cleanup}

clean_docker.sh

```{bash}
#!/bin/bash

services="database webserver proxy order auth"

docker stop $(docker ps -a | awk '/bookstore/ {print $1}')
docker rm $(docker ps -a | awk '/bookstore/ {print $1}')

for service in ${services}
do
    echo "Delete ${service} image"
    docker rmi bookstore_${service}
done

if [ -d services ]; then
    rm -rf services
fi
docker network rm bookstore

if [ -e consul ]; then
    rm -rf consul*
fi
```

###Szolgáltatásokhoz

####Init szkript\label{appendix-starter}

```{bash}
#!/bin/bash

IP_ADDR=$(hostname -I)
MASK=${IP_ADDR%.*}

while true; do
    FOUND=false
    for ADDR in $(seq 1 255); do
        echo "${MASK}.${ADDR}  ${IP_ADDR}"
        [[ "${MASK}.${ADDR}" == "${IP_ADDR}" ]] && continue
        ping -c 1  "${MASK}.${ADDR}"
        [ $? -eq 0 ] || continue
        echo "Try consul with ${MASK}.${ADDR}"
        consul agent -server \
                     -join "${MASK}.${ADDR}" \
                     -datacenter "bookstore" \
                     -data-dir "${CONSUL_DIR}" \
                       > /var/log/bookstore-consul.log &
        sleep 10
        cat /var/log/bookstore-consul.log
        if ps ax | grep -v grep | grep "consul" > /dev/null; then
            echo "Consul could run!!!"
            FOUND=true
            break
        fi
    done
    echo "${FOUND}"
    if [[ "${FOUND}" == "true" ]]; then
        break
    fi
done
<service>.sh
```

####Böngészés kódjai\label{appendix-http}

Login oldal:

```{PHP}
<?php

if(!isset( $_POST['username'], $_POST['password']))
{
    echo 'Please enter a valid username and password';
}
else
{
    $username = filter_var($_POST['username'], FILTER_SANITIZE_STRING);
    $password = filter_var($_POST['password'], FILTER_SANITIZE_STRING);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_URL,
        "http://auth:8081/auth/{$username}/{$password}"
    );
    $output = curl_exec($ch);
    $info = curl_getinfo($ch);
    if ($output === false || $info['http_code'] != 200) {
        header("Location: /login.php");
        die();
    }
    else {
        header("Location: /store.php");
        die();
    }
    curl_close($ch);
}
?>
```

Könyveket megjelenítő oldal:

```{PHP}
<html>
<head>
<title>Bookstore Microservice</title>
<link rel="stylesheet" type="text/css" href="main.css">
</head>
<body>

<div id="storeBox">
<h2>Books:</h2>

<table>
  <tbody>
    <tr><th>Name</th><th>Quantity</th></tr>

    <?php
      $servername = "database";
      $username = "store";
      $password = "store";
      $dbname = "bookstore";

      // Create connection
      $conn = new mysqli($servername, $username, $password, $dbname);
      // Check connection
      if ($conn->connect_error) {
          die("Connection failed: " . $conn->connect_error);
      }

      $sql = "SELECT * FROM store";
      $result = $conn->query($sql);

      if ($result->num_rows > 0) {
          // output data of each row
          while($row = $result->fetch_assoc()) {
              echo "<tr><td>" . $row["book_name"]. \
                "</td><td> " . $row["count"]. "</td></tr>";
          }
      } else {
          echo "0 results";
      }
      $conn->close();
    ?>

  </tbody>
</table>
</div>
<div id="orderBox">
<form action="order.php" method="post">
    <span>Name of Book: </span>\
        <input type="text" name="nameOfBook" /><br/>
    <span>Number of Books: </span>\
        <input type="text" name="numberOfBooks"/><br/>
    <input type="submit" name="send" value="Send"/>
</form>
</div>

</body>
</html>
```

####Adatbázis inicializálás\label{appendix-database}

Autentikáció:

```{SQL}
# Add permission to databases
GRANT ALL PRIVILEGES ON authenticate.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON authenticate.* TO 'root'@'localhost';
# Create Tables
CREATE TABLE user_auth
(
	user_id int NOT NULL AUTO_INCREMENT,
	username varchar(255) NOT NULL,
	password varchar(255) NOT NULL,
	credential varchar(255),
	PRIMARY KEY (user_id)
);
# Fill Tables
INSERT INTO user_auth (username, password)
VALUES ("test", "testpassword");
```

Bookstore raktár:

```{SQL}
# Add permission to databases
GRANT ALL PRIVILEGES ON bookstore.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON bookstore.* TO 'root'@'localhost';
# Create Tables
CREATE TABLE store
(
	store_id int NOT NULL AUTO_INCREMENT,
	book_name varchar(255) NOT NULL,
	count int NOT NULL,
	PRIMARY KEY (store_id)
);
CREATE TABLE reservation
(
	reservation_id int NOT NULL AUTO_INCREMENT,
	username varchar(255) NOT NULL,
	book_name varchar(255) NOT NULL,
	count int NOT NULL,
	res_date varchar(255),
	PRIMARY KEY (reservation_id)
);
# Fill Tables
INSERT INTO store (book_name, count)
VALUES ("Harry Potter and the Goblet of fire", 10);
INSERT INTO store (book_name, count)
VALUES ("Harry Potter and the Philosopher's Stone", 10);
INSERT INTO store (book_name, count)
VALUES ("Harry Potter and the Chamber of Secret", 10);
INSERT INTO store (book_name, count)
VALUES ("Lord of the Rings: Fellowship of the ring", 3);
INSERT INTO store (book_name, count)
VALUES ("Lord of the Rings: The Two Towers", 3);
INSERT INTO store (book_name, count)
VALUES ("Lord of the Rings: The Return of the King", 0);
```

###Pipeline job szkript\label{appendix-pipline}

Pipeline job full szkript:

```{Pipeline}
buildNames = [
    'build-auth-service',
    'build-database-service',
    'build-order-service',
    'build-proxy-service',
    'build-webserver-service'
]

def buildJobs = [:]

for (int i=0; i<buildNames.size(); ++i) {
    def buildName = buildNames[i]
    buildJobs[buildNames[i]] = {
        node {
            echo 'Running '+buildName+' build'
            build job: buildName
        }
    }
}

stage 'Build'
echo 'Building services ...'
parallel buildJobs
stage 'Deploy'
echo 'Deploying services ...'
build job: 'deploy-services'
stage 'Test'
echo 'Testing services ...'
build job: 'test-services'
stage 'Cleanup'
echo 'Cleaning up services ...'
build job: 'cleanup-services'
```

###Proxy\label{appendix-template}

Proxy konfigurációs minta:

```{config}
global
    log 127.0.0.1 local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000
    errorfile 500 /etc/haproxy/errors/500.http

frontend web
    bind *:80
    mode http
    default_backend nodes

backend nodes
    mode http
    balance roundrobin{{range "app.web"}}
    service {{.ID}} {{.Address}}:{{.Port}}{{end}}

frontend database
    bind *:3306
    default_backend dbnodes

backend dbnodes
    balance roundrobin{{range "app.database"}}
    service {{.ID}} {{.Address}}:{{.Port}}{{end}}

frontend order
    bind *:8888
    default_backend onodes

backend onodes
    balance roundrobin{{range "app.order"}}
    service {{.ID}} {{.Address}}:{{.Port}}{{end}}

frontend auth
    bind *:8081
    default_backend anodes

backend anodes
    balance roundrobin{{range "app.auth"}}
    service {{.ID}} {{.Address}}:{{.Port}}{{end}}
```

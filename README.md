## Installing
```bash
git clone https://github.com/Stormle/mumble-web
cd mumble-web
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./mykey.key -out mykey.crt
docker-compose up --build
```


#### Stop container:

```bash
docker-compose down
```
#### Connect via browser:
```bash
https://localhost:8080/
https://serverip:8080/
```
#### What is this fork?
This is a Mumble docker image based on the projects: 
https://github.com/johni0702/mumble-web
https://hub.docker.com/r/coppit/mumble-server 
Essentially these two combined, ported to Alpine Linux and automated further.

#### Changing Mumble server configurations
```bash
Edit the file: **"murmur.ini"**
```
**CAUTION!** In case you're tweaking the file "Serversetup2.sh", pay attention to line separators. You want to use LF.


#### Relevant ports:

 ```bash
Web-server: 8080 -> 8080
SSL: 443 -> 1443
Mumble-server: 64738 -> 64738
```

####SSL-certificates

Using self signed SSL-certificates the users will receive a warning message in the browser. You can circumvent this by either adding the certificate as a trusted certificate on the user's computer or getting real signed certificates.
```bash
mykey.key
mykey.crt
```

####In case you need a shell:

```bash
docker exec -it <container name> /bin/ash
```

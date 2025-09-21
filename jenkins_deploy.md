docker build -t my-jenkins:py-docker -f Dockerfile.jenkins .

docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  --restart=on-failure \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --group-add $(getent group docker | cut -d: -f3) \
  my-jenkins:py-docker

docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# To stop and remove 
docker stop jenkins || true
docker rm jenkins || true

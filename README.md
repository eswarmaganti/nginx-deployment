# Personal Portfolio Website - E2E CICD Pipeline using helm & Github Actions

## Application
- The application is a simple static webpage built using HTML, Bootstrap CSS and JavaScript.
- It's deployed as a container in Kubernetes Cluster using an image `eswarmaganti/portfolio:<tag>` built using nginx base image.

## How to run the application in your local
- Clone the repository using git
  - `git clone https://github.com/eswarmaganti/nginx-deployment.git`
- Local application testing using docker
  ```bash
  docker pull eswarmaganti/portfolio:<tag>
  
  # generate a self signed cert and mount it to the container
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key \
  -out tls.crt \
  -subj "/CN=portfolio.eswarmaganti.local"
  
  # add the hostname to the /etc/hosts file
  sudo echo "127.0.0.1  portfolio.eswarmaganti.local" >> /etc/hosts
  
  # run the docker container by mounting the certificate
  docker run -d  \
    --name portfolio\
    -p 5001:443
    -v $(pwd)/tls.key:/etc/nginx/ssl/tls.key
    -v $(pwd)/tls.crt:/etc/nginx/ssl/tls.crt
    eswarmaganti/portfolio:<tag>
  
  # access the application using curl or local browser
  curl -kv https://portfolio.eswarmaganti.local
  ```
- Export the below environment variables
  ```bash
  export DOCKERHUB_USERNAME=<value>
  export DOCKERHUB_PASSWORD=<value>
  export DOCKERHUB_EMAIL=<value>
  export ENVIRONMENT=<value>
  ```
- Deploy the kubernetes resources using the helm chart as below
  ```bash
  envsubst < charts/nginx/values.yaml > charts/nginx/values_${ENVIRONEMNT}.yaml # generate the values.yaml for deployment
  helm upgrade <release_name> charts/nginx -f charts/nginx/values_${ENVIRONEMNT}.yaml # deploy the resources using helm
  ```
- Post validations
  ```bash
  helm ls # check the deployed helm chart release
  kubectl get all -n ${ENVIRONMENT} # get all the resources deployed in the namespace
  kubectl get pods -n ${ENVIRONMENT} # get the details of running pod
  kubectl logs pod/<pod_name> -n ${ENVIRONMENT} # to get the logs of running pod
  
  # access the application using curl or local browser
  curl -kv https://portfolio.eswarmaganti.local
  ```
# OpenFaaS Functions
[![Build Status](https://travis-ci.com/MartinHeinz/openfaas-functions.svg?branch=master)](https://travis-ci.com/MartinHeinz/openfaas-functions)

This is repository for various function that use OpenFaaS platform.

For more information please see blog post here:

- [Going Serverless with OpenFaaS and Golang — The Ultimate Setup and Workflow](https://towardsdatascience.com/going-serverless-with-openfaas-and-golang-the-ultimate-setup-and-workflow-52a4a85a7951?source=friends_link&sk=7a844dc8e4421642dfd7530a112767da)

## Prerequisites

- **k3s**:
    
    ```bash
    curl -sfL https://get.k3s.io | sh -
    
    sudo cat /var/lib/rancher/k3s/server/node-token  # This is K3S_TOKEN
    
    export K3S_URL="http://localhost:6443"
    export K3S_TOKEN="..."
    
    sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
    sudo chown $(id -u):$(id -g) /home/martin/.kube/config
    
    kubectl get node
    kubectl config view

    ```
    
    If you get connection refused error try running `systemctl restart k3s`
    
    To add worker nodes, ssh into other machine, export variables as shown above and run `curl -sfL https://get.k3s.io | sh -`
    
- **OpenFaaS CLI**:

    ```bash
    curl -sL https://cli.openfaas.com | sudo sh
    ```
    
- **OpenFaaS**:

    ```bash
    git clone https://github.com/openfaas/faas-netes
    
    kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
    
    PASSWORD=$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)
    kubectl -n openfaas create secret generic basic-auth \
    --from-literal=basic-auth-user=admin \
    --from-literal=basic-auth-password="$PASSWORD"
    
    cd faas-netes && \
    kubectl apply -f ./yaml
    
    export OPENFAAS_URL=http://127.0.0.1:31112
    
    kubectl port-forward svc/gateway -n openfaas 31112:8080 &
    ```
    
    Open <http://127.0.0.1:31112> in browser and login with `admin` and `echo $PASSWORD`

- **Task (Taskfile)**:

    ```bash
    cd ~
    curl -sL https://taskfile.dev/install.sh | sh
    ```

    Or depending on your system: <https://taskfile.dev/#/installation>

## Usage

Before deploying functions, the Docker image needs to first be push to remote registry repository, this repository is specified using `PREFIX` variable in `Taskfile.yml`. You need to change its value to your _Docker Hub_ username.

- **Create**:

    Create function with specified name, using some template:
    ```bash
  task create TPL=golang-mod FUNC=my-func
    ```

- **Build**:

    Build specific function (Docker image):
    ```bash
  task build FUNC=my-func
    ```

- **Run**:

    Build, push and deploy function:
    ```bash
    task run FUNC=my-func
    ```

- **Logs**:

    View info and logs of function:
    ```bash
    task logs FUNC=my-func
    ```

- **Debug**:

    Run function locally (in Docker) and attach to `watchdog` process logs:
    ```bash
    task debug FUNC=my-func
    ```
    
    When the function is running you can hit it with _cURL_:
    ```bash
    curl -vvv --header "Content-Type: application/json" \
              --request POST \
              --data '{"key":"value"}' \
              127.0.0.1:8081
    ```
    
    You might also want to change timeouts of the function when debugging (`template.yml`):
    
    ```yaml
    functions:
        func_name:
          ...
          environment:
              read_timeout: 20
              write_timeout: 20
    ```

## Using Custom Templates

Custom templates are stored in [openfaas-templates](https://github.com/MartinHeinz/openfaas-templates) repository.

These are automatically pulled when running `task create ...`, if you want to use different template store, then change `OPENFAAS_TEMPLATE_STORE_URL` in `Taskfile.yml`

### Resources

- [Using template from external repository](https://github.com/openfaas/faas-cli/blob/master/guide/TEMPLATE.md)
- [OpenFaaS Function Store](https://github.com/openfaas/store/)
- [Customise a template](https://docs.openfaas.com/cli/templates/#80-customise-a-template)
- [Deployment Troubleshooting](https://docs.openfaas.com/deployment/troubleshooting/#function-execution-logs>)
- <https://blog.alexellis.io/serverless-golang-with-openfaas/>
- <https://blog.alexellis.io/test-drive-k3s-on-raspberry-pi/>
- <https://rancher.com/docs/k3s/latest/en/configuration/>
- <https://github.com/openfaas/templates/blob/master/template/dockerfile/function/Dockerfile>

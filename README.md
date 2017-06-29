# Sample Resources to Demonstrate the Usage of the Azure ACS (Kubernetes) Jenkins Plugin

The Azure ACS plugin for Jenkins helps to deploy Kubernetes or Marathon configurations to the Azure Container Service
with Kubernetes or DC/OS orchestrator, respectively.

In practice, before we can proceed with the deployment in Jenkins, we need to get the project deliveries ready. This is
illustrated with the resource in this project.

## 1. Prepare the Project Output

Prepare the target output from the project source. For compiled languages, this generally means compiling and proper 
packaging; for scripting languages we may need to assemble the assets and other resources.

This project is basically a Java Maven project, which builds a simple Spring Boot REST API service into a fat JAR, 
and copy the resources for Docker, Kubernetes and Marathon when the `mvn package` goal is executed:

* **Docker**: copy `src/main/docker/*` and the fat JAR to `target/docker`.
* **Kubernetes**: copy `src/main/kubernetes/*` to `target/kubernetes`.
* **Marathon**: copy `src/main/marathon/*` to `target/marathon`.

Jenkins ships with Maven support by default, we can configure the project to build with Maven with the `package` target
to get the project output.

## 2. Build the Docker Image Based on the Project Output

Both Kubernetes and Marathon deploy Docker image to the cluster. In order to get the latest project output to be
deployed to the cluster, we need to build a Docker image based on the output.

The `Dockerfile` in `src/main/docker` contains the image configuration. It copies the fat JAR and runs the main class
in that JAR. All the required resources will be copied to `target/docker`. We can use 
[CloudBees Docker Build and Publish plugin](https://wiki.jenkins-ci.org/display/JENKINS/CloudBees+Docker+Build+and+Publish+plugin), 
or any other similar Jenkins plugin to build the docker image and push it to a repository.

Note that in order to use the latest image built in this step, we must make sure the image name set in the Docker build
step is the same as that in the Kubernetes / Marathon configuration.

## 3. Deploy the Configurations to ACS

Add the post-build action *Deploy to Azure Container Service* provided by the Azure ACS plugin. Fill in the 
configuration details:

* **Azure Credentials**: The Azure Service Principal used to authenticate with Azure service. Refer to 
   [the documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal)
   on how to create the service principal.
* **Resource Group**: Select the resource group which your container service belongs to. Once you setup the Azure
   credentials correctly, the resource groups under that subscription will be populated to the dropdown automatically.
* **Container Service**: Select the container service from the given resource group.
* **Master Node SSH Credentials**: This is the SSH credentials used to login to the master node of the container service.
   Generally, when you create the Azure Container Service, it uses the private key at `~/.ssh/id_rsa` by default. The
   login credentials can be updated from Azure portal.
* **Config Files**: The configuration file paths in the Ant glob syntax. All the files matching the pattern will be 
   considered as the Kubernetes (or Marathon) configuration and be deployed to the cluster.
   
   For this project, we can use the project output from:
   
   * Kubernetes: `target/kubernetes/*.yml`
   * DC/OS Marathon: `target/marathon/*.json`
* **Enable Variable Substitution in Config**: This allows substitution of variables (in `$VARIABLE` or `${VARIABLE}`
   format) with the corresponding environment variable values.

   In a continuous build environment, we may generate some images with dynamic tags (e.g., the `$BUILD_NUMBER` as 
   used in this project). The substitution allows us to generate the actual configuration dynamically and use the image
   with the correct tag.

## Bare Configurations

This repo also includes the following configurations which defines the same deployment &amp; service as in the
[Azure Container Service Documentation](https://docs.microsoft.com/en-us/azure/container-service/container-service-kubernetes-walkthrough).
They use the public [Nginx image](https://hub.docker.com/_/nginx/) which do not need any explicit build actions.
You can use them as a quick reference to test your plugin / Kubernetes setup.

* `separated-config`

   Kubernetes configurations separated in a series files. Each one contains configuration for a specific resource 
   in the Kubernetes cluster.

* `joint-config`

   Kubernetes configurations combined in a List and stored in a single file.

* `marathon`

   Marathon configurations based on the nginx image.

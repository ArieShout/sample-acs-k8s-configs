# Sample Resources to Demonstrate the Usage of the Azure ACS (Kubernetes) Jenkins Plugin

This project is basically a Java Maven project, which builds a simple Spring Boot REST API service into a fat JAR, 
and copy the resources for Docker and Kubernetes when the `mvn package` goal is executed:

* **Docker**: copy `src/main/docker/*` and the fat JAR to `target/docker`.
* **Kubernetes**: copy `src/main/kubernetes/*` to `target/kubernetes`.

The Azure ACS (Kubernetes) Jenkins plugin scans the Kubernetes resource configurations and deploy them to the 
Kubernetes cluster. So the files in `target/kubernetes` can be used for the configuration update for the plugin. 
Before that we need to build the docker image from the `mvn package` output. This can be done with the 
[CloudBees Docker Build and Publish plugin](https://wiki.jenkins-ci.org/display/JENKINS/CloudBees+Docker+Build+and+Publish+plugin), 
or any other similar Jenkins plugin for docker image creation and push.  

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

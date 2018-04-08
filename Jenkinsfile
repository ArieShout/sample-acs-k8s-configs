node {
    def mvnHome
    stage('Preparation') { // for display purposes
        // Get some code from a GitHub repository
        git 'O:\\git\\sample-acs-k8s-configs.git'
        // Get the Maven tool.
        // ** NOTE: This 'M3' Maven tool must be configured
        // **       in the global configuration.
        mvnHome = tool 'M3'
    }
//    stage('Build') {
//       // Run the maven build
//       if (isUnix()) {
//          sh "'${mvnHome}/bin/mvn' -Dmaven.test.failure.ignore clean package"
//       } else {
//          bat(/"${mvnHome}\bin\mvn" -Dmaven.test.failure.ignore clean package/)
//       }
//    }
//    stage('Results') {
//       junit '**/target/surefire-reports/TEST-*.xml'
//       archive 'target/*.jar'
//    }
//     stage('Push') {
//         bat """cd target/docker
//                docker build -t menxiao/menxiao-k8s-demo:${BUILD_NUMBER} .
//                docker push menxiao/menxiao-k8s-demo:${BUILD_NUMBER}"""
//     }
    stage('Deploy') {
        withEnv(['DOCKER_IMAGE_TAG=26']) {
            kubernetesDeploy configs: 'src/main/kubernetes/test.yml',
                                credentialsType: 'SSH',
                                enableConfigSubstitution: true,
                                ssh: [
                                    sshCredentialsId: '21cef8a3-34dc-4de0-af7f-a5d4df23493f',
                                    sshServer: '52.187.188.237'
                                ],
                                dockerCredentials: [[credentialsId: '528a0520-44f5-4f91-abbd-e6cfa1d0c83b']]
        }
   }
}

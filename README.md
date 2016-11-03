docker-jenkins-slave
====================

Docker Jenkins slave image using swarm plugin and supports Docker in Docker

    OS Base : docker:dind (alpine based)
    Jenkins Swarm version :  2.2
    Exposed Port : 22
    Jenkins Home : /jenkins
    Timezone : GMT

Environment Variables
---------------------
    JENKINS_JAVA_ARGS
        Arguments to pass to Java when Jenkins starts. Default : '-Djava.awt.headless=true'
    JENKINS_SSH_PUBKEY
        SSH Public key that is added to Jenkins user authorized_keys file
    JENKINS_PASSWD
        By default, the Jenkins SSH account password is randomally generated,
        however you can set this environment variable to set it yourself.
    TZ
        Container Timezone. Default 'GMT'

Services
--------

  * Jenkins Slave
  * Docker in Docker
  * SSHD

You can ssh to the container by exposing port 22 on your Docker host and using the username
`jenkins`. Password can be found by running:

    docker logs <CONTAINER_ID> 2>/dev/null | grep JENKINS_PASSWORD

Swarm Client Startup Options
----------------------------
Below is a list of environment variables that are mapped to the the swarm client options. Simply pass them to the container
when you run.

    JENKINS_MASTER_URL                : -master
    JENKINS_AUTODISC_ADDR             : -autoDiscoveryAddress
    JENKINS_EXECUTORS                 : -executors
    JENKINS_LABELS                    : -labels
    JENKINS_USERNAME                  : -username
    JENKINS_PASSWORD                  : -password
    JENKINS_CANDIDATE_TAG             : -candidateTag
    JENKINS_DELETE_EXISTING_CLIENTS   : -deleteExistingClients
    JENKINS_DELETE_EXISTING_CLIENTS   : -deleteExistingClients
    JENKINS_DESCRIPTION               : -description
    JENKINS_DISABLE_CLIENTS_UNIQUE_ID : -disableClientsUniqueId
    JENKINS_DISABLE_SSL_VERIFICATION  : -disableSslVerification
    JENKINS_MODE                      : -mode
    JENKINS_NAME                      : -name
    JENKINS_NO_RETRY_AFTER_CONNECTED  : -noRetryAfterConnected
    JENKINS_RETRY                     : -retry
    JENKINS_SHOW_HOST_NAME            : -showHostName
    JENKINS_RETRY                     : -retry
    JENKINS_TOOL_LOCATIONS            : -t
    JENKINS_TUNNEL                    : -tunnel

The autodiscovery will work if the slave is on the same network as the Jenkins master. The default configuration of Docker will
prevent it from working if slave and master are on different Docker hosts. In this case you will need to pass in the environment
variable ```JENKINS_MASTER_URL```

#!/bin/bash

# Read Env Vars set by Docker
source /docker.env

if ! id jenkins &>/dev/null
then
  addgroup docker
  adduser -G docker -s /bin/bash -h ${JENKINS_HOME} -D jenkins

  # Set Jenkins user password, so we can SSH
  [ -z "$JENKINS_PASSWD" ] && JENKINS_PASSWD=$(openssl rand -base64 6)
  echo JENKINS_PASSWORD=${JENKINS_PASSWD}
  echo -e "${JENKINS_PASSWD}\n${JENKINS_PASSWD}" | passwd jenkins &>/dev/null
fi

mkdir -p ${JENKINS_HOME}/.ssh
[ "${JENKINS_SSH_PUBKEY}" ] && echo "${JENKINS_SSH_PUBKEY}" >> ${JENKINS_HOME}/.ssh/authorized_keys

chown -R jenkins ${JENKINS_HOME}

OPTS="-fsroot '${JENKINS_HOME}'"

if [ -n "${JENKINS_MASTER_URL}" ]
then
  OPTS+=" -master '${JENKINS_MASTER_URL}'"
elif [ -n "${JENKINS_AUTODISC_ADDR}" ]
then
  OPTS+=" -autoDiscoveryAddress '${JENKINS_AUTODISC_ADDR}'"
fi

if [ -n "${JENKINS_EXECUTORS}" ]
then
  OPTS+=" -executors ${JENKINS_EXECUTORS}"
fi

if [ -n "${JENKINS_LABELS}" ]
then
  OPTS+=" -labels '${JENKINS_LABELS}'"
fi

if [ -n "${JENKINS_USERNAME}" ] && ([ -n "${JENKINS_PASSWORD}" ] || [ -n "${JENKINS_PASSWORD_ENV_VARIABLE}" ])
then
  OPTS+=" -username '${JENKINS_USERNAME}'"
  if [ -n "${JENKINS_PASSWORD}" ]
  then
    OPTS+=" -password '${JENKINS_PASSWORD}'"
  elif [ -n "${JENKINS_PASSWORD_ENV_VARIABLE}" ]
  then
    OPTS+=" -passwordEnvVariable '${JENKINS_PASSWORD_ENV_VARIABLE}'"
  fi
fi

if [ -n "${JENKINS_CANDIDATE_TAG}" ]
then
  OPTS+=" -candidateTag '${JENKINS_CANDIDATE_TAG}'"
fi

if [ -n "${JENKINS_DELETE_EXISTING_CLIENTS}" ]
then
  OPTS+=" -deleteExistingClients"
fi

if [ -n "${JENKINS_DELETE_EXISTING_CLIENTS}" ]
then
  OPTS+=" -deleteExistingClients"
fi

if [ -n "${JENKINS_DESCRIPTION}" ]
then
  OPTS+=" -description ${JENKINS_DESCRIPTION}"
fi

if [ -n "${JENKINS_DISABLE_CLIENTS_UNIQUE_ID}" ]
then
  OPTS+=" -disableClientsUniqueId"
fi

if [ -n "${JENKINS_DISABLE_SSL_VERIFICATION}" ]
then
  OPTS+=" -disableSslVerification"
fi

if [ -n "${JENKINS_MODE}" ]
then
  OPTS+=" -mode '${JENKINS_MODE}'"
fi

if [ -n "${JENKINS_NAME}" ]
then
  OPTS+=" -name '${JENKINS_NAME}'"
fi

if [ -n "${JENKINS_NO_RETRY_AFTER_CONNECTED}" ]
then
  OPTS+=" -noRetryAfterConnected"
fi

if [ -n "${JENKINS_RETRY}" ]
then
  OPTS+=" -retry ${JENKINS_RETRY}"
fi

if [ -n "${JENKINS_SHOW_HOST_NAME}" ]
then
  OPTS+=" -showHostName"
fi

if [ -n "${JENKINS_RETRY}" ]
then
  OPTS+=" -retry ${JENKINS_RETRY}"
fi

if [ -n "${JENKINS_TOOL_LOCATIONS}" ]
then
  for tool in $(echo "${JENKINS_TOOL_LOCATIONS}" | tr ";" "\n")
  do
    OPTS+=" -t '${tool}'"
  done
fi

if [ -n "${JENKINS_TUNNEL}" ]
then
  OPTS+=" -tunnel ${JENKINS_TUNNEL}"
fi

cd ${JENKINS_HOME}
echo "### Jenkins Swarm client options ###"
echo "### ${OPTS} ###"

su - jenkins -c "java ${JENKINS_JAVA_OPTS} -jar swarm-client.jar ${OPTS} &>$JENKINS_HOME/jenkins_swarm_client.log & echo \$! > /tmp/jenkins.pid"

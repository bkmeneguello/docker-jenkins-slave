FROM docker:dind
MAINTAINER Bruno Meneguello "bruno@meneguello.com"
ENV JENKINS_HOME /jenkins
ENV JENKINS_SWARM_CLIENT_VER 2.2
ENV JENKINS_JAVA_ARGS '-Djava.awt.headless=true'
ENV TZ GMT
ENV DEBIAN_FRONTEND noninteractive
EXPOSE 2812 22

RUN apk add --no-cache \
            bash \
            openssh \
            curl \
            openjdk7-jre-base \
            git \
            subversion

ADD ./jenkins.sudoers /etc/sudoers.d/jenkins
ADD ./jenkins_init_wrapper.sh /jenkins_init_wrapper.sh
ADD ./start.sh /start.sh

RUN ln -s /usr/local/bin/docker /usr/bin/docker && \
      mkdir -p ${JENKINS_HOME} && curl -s -L -o $JENKINS_HOME/swarm-client.jar \
      https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${JENKINS_SWARM_CLIENT_VER}/swarm-client-${JENKINS_SWARM_CLIENT_VER}-jar-with-dependencies.jar

ENTRYPOINT ["/bin/bash", "/start.sh"]

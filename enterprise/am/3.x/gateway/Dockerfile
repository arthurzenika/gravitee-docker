#-------------------------------------------------------------------------------
# Copyright (C) 2015 The Gravitee team (http://gravitee.io)
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#            http://www.apache.org/licenses/LICENSE-2.0
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#-------------------------------------------------------------------------------
FROM eclipse-temurin:11-jre-focal
LABEL maintainer="contact@graviteesource.com"

ARG GRAVITEEIO_AM_VERSION=0
ARG GRAVITEEIO_DOWNLOAD_URL=https://download.gravitee.io/graviteeio-ee/am/distributions
ENV GRAVITEEIO_HOME /opt/graviteeio-am-gateway

RUN apt-get update \
    && apt-get --yes upgrade \
    && apt-get --yes install wget unzip htop \
	&& wget ${GRAVITEEIO_DOWNLOAD_URL}/graviteeio-ee-am-full-${GRAVITEEIO_AM_VERSION}.zip --no-check-certificate -P /tmp \
    && unzip /tmp/graviteeio-ee-am-full-${GRAVITEEIO_AM_VERSION}.zip -d /tmp/ \
    && mv /tmp/graviteeio-ee-am-full-${GRAVITEEIO_AM_VERSION}/graviteeio-am-gateway* ${GRAVITEEIO_HOME} \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/* \
	&& chgrp -R 0 ${GRAVITEEIO_HOME} \
    && chmod -R g=u ${GRAVITEEIO_HOME}

WORKDIR ${GRAVITEEIO_HOME}

EXPOSE 8092
CMD ["./bin/gravitee"]

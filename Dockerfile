FROM node:alpine

LABEL authors="Raí V. Adriano <raivieiraadriano92@gmail.com>, \ 
	Cristian B. Santos<cbsan.dev@gmail.com>, \
	Luiz C. R. Correa<luiz.correa.dev@gmail.com>"

ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_TOOLS=$ANDROID_HOME/tools
ENV ANDROID_PLATFORM_TOOLS=$ANDROID_HOME/platform-tools
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=$PATH:$ANDROID_TOOLS:$ANDROID_PLATFORM_TOOLS:$JAVA_HOME/jre/bin
ENV URL_SDK_ANDROID=https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip

RUN set -xe \
	&& { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home \
	&& INSTALL_TEMP="\
		curl \
		gcc  \
		unzip " \
	&& INSTALL="\
		openjdk8-jre=8.181.13-r0 " \
	&& apk add --no-cache --virtual .persistent-deps $INSTALL_TEMP $INSTALL \
	&& NPM_INSTALL_GLOBAL="\
	yarn \
	react-native" \
	&& npm i -g $NPM_INSTALL_GLOBAL \
	&& curl -fsSL $URL_SDK_ANDROID -o /tmp/sdk.zip \
	&& mkdir -p $ANDROID_HOME \
	&& unzip /tmp/sdk.zip -d $ANDROID_HOME \
	&& yes | $ANDROID_TOOLS/bin/sdkmanager  "platform-tools" "platforms;android-27" "build-tools;27.0.3" \
	&& rm -rf /tmp/* \
	&& apk del .persistent-deps $INSTALL_TEMP
FROM centos:7
MAINTAINER Stephen Bunn, scbunn@sbunn.org

ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_MAJOR 7
ENV TOMCAT_VERSION 7.0.69
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
ENV JAVA_HOME=/usr/java/latest

# Pre-build layer.  This layer is a minimal layer to ensure we have the latest
# packages and a working WORKDIR
RUN mkdir -p "$CATALINA_HOME/bin" &&\
    yum upgrade -y &&\
    yum clean all &&\
    curl -fSL https://github.com/tianon/gosu/releases/download/1.9/gosu-amd64 -o /sbin/gosu &&\
    chmod +x /sbin/gosu 

WORKDIR $CATALINA_HOME

# Java Layer.
# This layer installs and configures the latest version of the JDK
RUN  curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.rpm > /tmp/jdk8.rpm &&\
     rpm -Uvh /tmp/jdk8.rpm &&\
     rm -rf /tmp/jdk8.rpm

# Build Layer.
# This layer installs the base tomcat components
COPY docker-entrypoint.sh /
COPY setenv.sh $CATALINA_HOME/bin
RUN curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz &&\
    tar xvf tomcat.tar.gz --strip-components=1 &&\
    rm bin/*.bat &&\
    rm tomcat.tar.gz* &&\
    rm -rf /opt/tomcat/NOTICE /opt/tomcat/RELEASE-NOTES /opt/tomcat/RUNNING.txt &&\
    rm -rf /opt/tomcat/webapps/examples /opt/tomcat/webapps/docs &&\
    groupadd tomcat &&\
    useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat &&\
    chown -R tomcat:tomcat /opt/tomcat &&\
    chmod +x /docker-entrypoint.sh &&\
    chmod +x $CATALINA_HOME/bin/setenv.sh

# Native Libraries
# This layer builds and installs APR/Native
RUN yum install -y gcc make apr apr-devel openssl-devel &&\
    nativeBuildDir="$(mktemp -d)" &&\
    tar xvf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1 &&\
    cd "$nativeBuildDir/jni/native" &&\
    ./configure --with-apr=/usr/bin/apr-1-config \
                --prefix=$CATALINA_HOME \
                --with-ssl=yes &&\
     make -j2 &&\
     make install &&\
     rm -f /usr/lib/libtcnative-1.so &&\
     ln -s $CATALINA_HOME/lib/libtcnative-1.so.0.1.33 /usr/lib/libtcnative-1.so &&\
     rm -rf $nativeBuildDir &&\
     yum erase -y make openssl-devel keyutils-libs-devel krb5-devel libcom_err-devel libselinux-devel \
                  libsepol-devel libverto-devel pcre-devel zlib-devel apr-devel gcc cpp mpfr \
                  kernel-headers glibc-devel libgomp glibc-headers &&\
     rm -rf /opt/tomcat/bin/tomcat-native.tar.gz &&\
     cd $CATALINA_HOME &&\
     bin/catalina.sh configtest &&\
     rm -rf /opt/tomcat/logs/* &&\
     yum clean all

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["tomcat"]

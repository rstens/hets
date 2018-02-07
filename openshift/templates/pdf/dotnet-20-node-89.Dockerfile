FROM registry.access.redhat.com/dotnet/dotnet-20-rhel7
# This image provides a .NET Core 2.0 and upgraded Node environment you can use 
# to run your .NET applications.

ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

# This setting is a workaround for issues with dotnet and certain docker versions
ENV LTTNG_UST_REGISTER_TIMEOUT 0

# Switch to root for package installs
USER 0

# Install git
RUN yum install -y bzip2 git && \
    yum clean all -y

# Install phantomjs
RUN yum install unzip
RUN curl -O https://github.com/ariya/phantomjs/archive/2.1.3.zip

RUN ls -la
RUN unzip 2.1.3.zip

RUN ls -la
RUN cp 2.1.3/phantomjs-2.1.3/bin/phantomjs /usr/local/bin

RUN yum install freetype
RUN yum install fontconfig	
	
# Remove old version of Node
RUN rm -R /opt/rh/rh-nodejs6

# Install newer version of Node 
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION  v8.9.1

RUN touch ~/.bash_profile \
    && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm ls-remote \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install -g autorest

RUN chmod -R a+rwx /usr/local/nvm
RUN mkdir -p /opt/app-root
RUN chmod -R a+rwx /opt/app-root
RUN chown -R 1001:0 /opt/app-root && fix-permissions /opt/app-root

# Run container by default as user with id 1001 (default)
USER 1001

env PATH "$PATH:/usr/local/nvm/versions/node/v8.9.1/bin/" 

# Directory with the sources is set as the working directory.
WORKDIR /opt/app-root/src

# Set the default CMD to print the usage of the language image.
CMD /usr/libexec/s2i/usage

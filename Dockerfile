#FROM python:3
FROM jupyter/minimal-notebook:latest
ENV PYTHONUNBUFFERED=1

USER root
WORKDIR /usr/src/app

# install Microsoft SQL Server requirements.
ENV ACCEPT_EULA=Y
RUN apt-get update -y && apt-get update \
   && apt-get install -y --no-install-recommends curl gcc g++ gnupg unixodbc-dev


# Installing Oracle instant client
WORKDIR    /opt/oracle
RUN apt-get update && apt-get install -y libaio1 wget unzip \
    && wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip \
    && unzip instantclient-basiclite-linuxx64.zip \
    && rm -f instantclient-basiclite-linuxx64.zip \
    && cd /opt/oracle/instantclient* \
    && rm -f *jdbc* *occi* *mysql* *README *jar uidrvci genezi adrci \
    && echo /opt/oracle/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf \
    && ldconfig

# Get SQL Server driver
#RUN apt-get update \
#        && apt-get install -y curl apt-transport-https gnupg2 \
#        && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
#        && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
#        && apt-get update \
#        && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools unixodbc-dev

# Copy files and install Python packages
WORKDIR /code
#COPY requirements.txt /code/
#RUN pip install -I -r requirements.txt
#COPY . /code/

# WORKDIR /queries
# COPY queries/*.sql /queries/

RUN mkdir ~/.ssh && ln -s /run/secrets/host_ssh_key ~/.ssh/id_rsa

# Install MSSQL driver
RUN apt-get update \
	&& apt-get install -y curl apt-transport-https gnupg2 \
	&& curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
	&& curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
	&& apt-get update \
	&& ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools unixodbc-dev

# Add any necessary ssh (+ sftp) known hosts here!
#RUN ssh-keyscan -H [FAKE.SERVER.COM] >> ~/.ssh/known_hosts

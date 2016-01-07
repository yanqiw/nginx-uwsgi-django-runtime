#FROM python:2.7
FROM ubuntu:14.04
ENV PYTHONUNBUFFERED 1

#install nginx, database drivers, sqlite3, mysql, postgresql
RUN apt-get update
RUN apt-get install -y python python-dev python-setuptools
RUN apt-get install -y nginx supervisor
RUN easy_install pip

RUN apt-get install -y \
		mysql-client libmysqlclient-dev \
		postgresql-client libpq-dev \
		sqlite3 \
		gcc \
	--no-install-recommends && rm -rf /var/lib/apt/lists/*ß


#add code
RUN mkdir /code
WORKDIR /code

# setup all the configfiles
ADD . /code
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN cp /code/nginx/nginx-app.conf /etc/nginx/sites-enabled/
RUN cp /code/nginx/supervisor-app.conf /etc/supervisor/conf.d/

#install python package
RUN pip install -r requirements.txt

#build existed project
ONBUILD ADD requirements.txt /code/
ONBUILD RUN pip install -r requirements.txt
ONBUILD ADD . /code/


#create socket folder, as for the development runtime, the code will be volumed, the socket should be saved in other folder
RUN mkdir /socket

EXPOSE 80

CMD ["supervisord", "-n"]

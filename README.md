"Nginx + uWSGI + Django" development runtime
====
#Overall
This repo is used to store "Nginx + uWSGI + Django" runtime docker image generation file. The overall steps refres to [dockerfiles/django-uwsgi-nginx](https://github.com/dockerfiles/django-uwsgi-nginx)

#Who should use this repo
- if you want need a runtime for development
- if you want to build a image with Nginx + uWSGI + django arcthicture

#How to use this repo
##Build runtime image with your code
You can create below Dockerfile in your project root
```Dockerfile
FROM yanqiw/nginx-uwsgi-django
```
Build the image
```bash
docker build -t your/project/tag .
```

##Run the container
###For development runtime
###uwsgi.ini
You need to create your project uwsgi.ini in your project root:
```
[uwsgi]
# this config will be loaded if nothing specific is specified
# load base config from below
ini = :base

# %d is the dir this configuration file is in
socket = /socket/app.sock
master = true
processes = 4

[dev]
ini = :base
# socket (uwsgi) is not the same as http, nor http-socket
socket = :8001


[local]
ini = :base
http = :8000

[base]
# chdir to the folder of this config file, plus app/website
chdir = %d
# load the module from wsgi.py, it is a python path from
# the directory above.
module=mysite.wsgi:application
# allow anyone to connect to the socket. This is very permissive
chmod-socket=666
```
###uwsgi_params
You need to create your project uwsgi_params in your project root:
```
uwsgi_param  QUERY_STRING       $query_string;
uwsgi_param  REQUEST_METHOD     $request_method;
uwsgi_param  CONTENT_TYPE       $content_type;
uwsgi_param  CONTENT_LENGTH     $content_length;

uwsgi_param  REQUEST_URI        $request_uri;
uwsgi_param  PATH_INFO          $document_uri;
uwsgi_param  DOCUMENT_ROOT      $document_root;
uwsgi_param  SERVER_PROTOCOL    $server_protocol;
uwsgi_param  HTTPS              $https if_not_empty;

uwsgi_param  REMOTE_ADDR        $remote_addr;
uwsgi_param  REMOTE_PORT        $remote_port;
uwsgi_param  SERVER_PORT        $server_port;
uwsgi_param  SERVER_NAME        $server_name;
```
if you want to run the container as a runtime for your development, you can mount your code do the '/code' folder.
```bash
docker run --name my-project -d -v /path/to/your/project:/code -p 8000:80 your/project/tag
```
Before running nginx, you have to collect all Django static files in the static folder. First of all you have to edit mysite/settings.py adding:
```python
STATIC_ROOT = os.path.join(BASE_DIR, "static/")
```

Collect static files when you first time to run the container, and after each time you add static file to your project. You can collect the files by below command.
```bash
docker exec -it my-project python manage.py collectstatic
```
Open "http://yourhost:8000" in browser to check the result.

#Architecture overview of this runtime
TBD

#Customization
TBD

#How to debug
If there are any error, you can check below logs in the container
- /var/log/supervisor
- /var/log/nginx
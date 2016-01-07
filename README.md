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
if you want to run the container as a runtime for your development, you can mount your code do the '/code' folder.
```bash
docker run --name my-project -d -v /path/to/your/project:/code -p 8000:80 your/project/tag
```
You may to collect static files when you first time to run the container, and after each time you add static file to your project. You can collect the files by below command.
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
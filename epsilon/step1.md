## Welcome to Django

### Getting Started

Create a new project:

`django-admin startproject mysite`{{execute}}

Move into the new directory:

`cd mysite`{{execute}}

Apply migrations:

`python manage.py migrate`{{execute}}

Update ALLOWED_HOSTS:

https://docs.djangoproject.com/en/3.2/ref/settings/#allowed-hosts

`sed -i 's/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \[".environments.katacoda.com"\]/g' mysite/settings.py`{{execute}}

Run your project:

`python manage.py runserver 0.0.0.0:8000`{{execute}}

Click the + next to the "Terminal" tab and choose "View HTTP port 8000 on Client 1"

You should see the Django "Congratulations" page.


## When you're done

When you're finished exploring the sandbox, click "Continue" to end this session.
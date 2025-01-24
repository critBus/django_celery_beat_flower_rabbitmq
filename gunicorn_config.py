workers = 4
bind = "0.0.0.0:8000"
chdir = "/app/"
module = "djangocelery.wsgi:application"
timeout = 120
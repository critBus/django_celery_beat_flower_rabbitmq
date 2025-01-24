import os

from celery import Celery
from djangocelery import settings

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "djangocelery.settings")
app = Celery("djangocelery")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)
@app.on_after_configure.connect
def setup_periodic_tasks(sender, **kwargs) -> None:
    # Example of periodic task (will be executed every 30 seconds)
    sender.add_periodic_task(30, periodic_task.s(), name='Periodic task example')


@app.task(name="PeriodicTask (every 30 seconds)")
def periodic_task() -> None:
    print("Example of periodic task executed!")

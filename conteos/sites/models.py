from django.db import models

# Create your models here.


class CountSite(models.Model):
    name = models.CharField(max_length=200)
    start_date = models.DateTimeField("start date")
    stop_date = models.DateTimeField("stop date")
    city = models.CharField(max_length=100)
    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)
    phone_number = models.CharField(max_length=100, null=True, blank=True)
    email = models.CharField(max_length=100, null=True, blank=True)
    link_url = models.CharField(max_length=100, blank=True, null=True)
    ebird_trip_report_url = models.CharField(max_length=100, blank=True, null=True)

    def __str__(self):
        return f'{self.name} ({self.start_date.date()})'
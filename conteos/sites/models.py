from django.db import models

# Create your models here.


class CountSite(models.Model):
    name = models.CharField(max_length=200)
    start_date = models.DateTimeField("start date")
    stop_date = models.DateTimeField("stop date")
    city = models.CharField(max_length=100)
    latitude = models.FloatField(blank=True, null=True, help_text='Between -5 and 5 usually')
    longitude = models.FloatField(blank=True, null=True, help_text='Between -75 and -85 usually')
    phone_number = models.CharField(max_length=10, null=True, blank=True,
                                    help_text='One number, Ecuadorian phones only')
    email = models.CharField(max_length=100, null=True, blank=True)
    link_url = models.CharField(max_length=100, blank=True, null=True,
                                help_text='Link for an image (you can use https://postimages.org)')
    ebird_trip_report_url = models.CharField(max_length=100, blank=True, null=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f'{self.name} ({self.start_date.date()})'

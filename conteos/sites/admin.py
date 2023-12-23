from django.contrib import admin

from sites.models import CountSite


@admin.register(CountSite)
class CountSiteAdmin(admin.ModelAdmin):
    """
    Manipulate CountSite.
    """
    list_display = ['name', 'start_date', 'stop_date']

from django.contrib import admin

from sites.models import CountSite


@admin.register(CountSite)
class CountSiteAdmin(admin.ModelAdmin):
    """
    Manipulate CountSite.
    """
    list_display = ['name', 'start_date', 'stop_date', 'is_active']
    list_filter = ['is_active']

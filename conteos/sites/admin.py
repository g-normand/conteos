from django.contrib import admin
from django import forms
from django.utils import timezone
from sites.models import CountSite

OFFSET = 5  # EC is UTC-5:00


class CountSiteForm(forms.ModelForm):
    date = forms.DateField()

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        new_date = timezone.now().replace(year=2024, month=5, day=11)
        self.fields["start_date"].initial = new_date.replace(hour=7 + OFFSET, minute=0, second=0)
        self.fields["stop_date"].initial = new_date.replace(hour=11 + OFFSET, minute=0, second=0)


@admin.register(CountSite)
class CountSiteAdmin(admin.ModelAdmin):
    """
    Manipulate CountSite.
    """
    list_display = ['name', 'start_date', 'stop_date', 'is_active']
    list_filter = ['is_active']
    form = CountSiteForm

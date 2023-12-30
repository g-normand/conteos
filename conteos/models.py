from datetime import datetime

from sqlalchemy import Integer, String, DateTime
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy_serializer import SerializerMixin

from db_config import db


class User(db.Model):
    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    username: Mapped[str] = mapped_column(String, unique=True, nullable=False)
    email: Mapped[str] = mapped_column(String)


class CountSite(db.Model, SerializerMixin):
    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String)
    start_date: Mapped[datetime] = mapped_column(DateTime)
    stop_date: Mapped[datetime] = mapped_column(DateTime)
    city: Mapped[str] = mapped_column(String)
    latitude: Mapped[str] = mapped_column(String, nullable=True)
    longitude: Mapped[str] = mapped_column(String, nullable=True)
    link_url: Mapped[str] = mapped_column(String, nullable=True)
    ebird_trip_report_url: Mapped[str] = mapped_column(String, nullable=True)

    def __str__(self):
        return f'{self.name} ({self.start_date.date()})'

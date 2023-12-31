from datetime import datetime

from sqlalchemy import Column, Integer, String, DateTime, Sequence

from conteos.db_config import Base


class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, Sequence('id_seq'), primary_key=True)
    username = Column(String(50))
    email = Column(String(50))


class CountSite(Base):
    __tablename__ = 'count_sites'
    id = Column(Integer, Sequence('id_count'), primary_key=True)
    name = Column(String(100))
    #start_date = Mapped[datetime] = mapped_column(DateTime)
    #stop_date = Mapped[datetime] = mapped_column(DateTime)
    city = Column(String(100))
    latitude = Column(String(100), nullable=True)
    longitude = Column(String(100), nullable=True)
    link_url = Column(String(100), nullable=True)
    ebird_trip_report_url = Column(String(100), nullable=True)

    def __str__(self):
        return f'{self.name} ({self.start_date.date()})'

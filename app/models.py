from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import MetaData, String, Integer, Text, DateTime, ForeignKey, Table, Column
from datetime import datetime
import os
import sqlalchemy as sa
from werkzeug.security import check_password_hash, generate_password_hash
from flask_login import UserMixin
from flask import current_app, url_for
from sqlalchemy.orm import Mapped, mapped_column, DeclarativeBase, relationship
from check_rights import CheckRights

naming_convention = {
    "ix": 'ix_%(column_0_label)s',
    "uq": "uq_%(table_name)s_%(column_0_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s"
}

class Base(DeclarativeBase):
    metadata = MetaData(naming_convention=naming_convention)

db = SQLAlchemy(model_class=Base)

association_table = Table('book_genre',
                          db.metadata,
                          Column('book_id', Integer, ForeignKey('books.id'), primary_key=True),
                          Column('genre_id', Integer, ForeignKey('genres.id'), primary_key=True))


class Book(db.Model):
    __tablename__ = 'books'
    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    brief_description: Mapped[str] = mapped_column(Text, nullable=False)
    year: Mapped[str] = mapped_column(String(4), nullable=False)
    publisher: Mapped[str] = mapped_column(String(100), nullable=False)
    author: Mapped[str] = mapped_column(String(100), nullable=False)
    volume: Mapped[int] = mapped_column(Integer, nullable=False)
    total_rating: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    number_of_ratings: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    image_id: Mapped[str] = mapped_column(String(100), ForeignKey('images.id'))
    genres: Mapped[list["Genre"]] = relationship('Genre', secondary=association_table, backref='books', cascade="all,delete")
    image: Mapped["Image"] = relationship('Image', cascade="all,delete")

    def __repr__(self):
        return '<Book %r>' % self.name

    @property
    def rating(self):
        if self.number_of_ratings > 0:
            return self.total_rating / self.number_of_ratings
        return 0


class Genre(db.Model):
    __tablename__ = 'genres'
    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)

    def __repr__(self):
        return '<Genre %r>' % self.name


class Image(db.Model):
    __tablename__ = 'images'
    id: Mapped[str] = mapped_column(String(100), primary_key=True)
    filename: Mapped[str] = mapped_column(String(100), nullable=False)
    mimetype: Mapped[str] = mapped_column(String(100), nullable=False)
    hash_md5: Mapped[str] = mapped_column(String(100), nullable=False, unique=True)

    def __repr__(self):
        return '<Image %r>' % self.filename

    @property
    def stored_file_name(self):
        _, ext = os.path.splitext(self.filename)
        return self.id + ext

    @property
    def file_url(self):
        return url_for('image', image_id=self.id)


class Review(db.Model):
    __tablename__ = 'reviews'
    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    mark: Mapped[int] = mapped_column(Integer, nullable=False)
    text: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, nullable=False, server_default=sa.sql.func.now())
    book_id: Mapped[int] = mapped_column(Integer, ForeignKey('books.id'))
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey('users.id'))

    user: Mapped["User"] = relationship('User', cascade="all,delete")
    book: Mapped["Book"] = relationship('Book', cascade="all,delete")

    def retrieve_user(self):
        return db.session.execute(db.select(User).filter_by(id=self.user_id)).scalar().full_name

    def __repr__(self):
        return '<Review %r>' % self.text


class User(db.Model, UserMixin):
    __tablename__ = 'users'

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    last_name: Mapped[str] = mapped_column(String(100), nullable=False)
    first_name: Mapped[str] = mapped_column(String(100), nullable=False)
    middle_name: Mapped[str] = mapped_column(String(100))
    login: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    password_hash: Mapped[str] = mapped_column(String(256), nullable=False)
    role_id: Mapped[int] = mapped_column(Integer, ForeignKey('roles.id'))

    def update_password(self, password):
        self.password_hash = generate_password_hash(password)

    def validate_password(self, password):
        return check_password_hash(self.password_hash, password)

    def has_admin_rights(self):
        return self.role_id == current_app.config["ADMIN_ROLE_ID"]

    def has_moderator_rights(self):
        return self.role_id == current_app.config["MODERATOR_ROLE_ID"]

    def can(self, action, record=None):
        check_rights = CheckRights(record)
        method = getattr(check_rights, action, None)
        if method:
            return method()
        return False

    @property
    def full_name(self):
        return ' '.join([self.first_name, self.last_name, self.middle_name or ''])

    def __repr__(self):
        return '<User %r>' % self.login


class Role(db.Model):
    __tablename__ = 'roles'

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)

    def __repr__(self):
        return '<Role %r>' % self.name

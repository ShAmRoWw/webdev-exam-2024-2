import math
from flask import Flask, render_template, request, send_from_directory
from sqlalchemy import desc
from flask_migrate import Migrate
from auth import bp as auth_bp, init_login_manager
from reviews import bp as reviews_bp
from models import Image, Book, Genre
from books import books_bp

app = Flask(__name__)
application = app

app.config.from_pyfile('config.py')

from models import db

db.init_app(app)
migrate = Migrate(app, db)

app.register_blueprint(auth_bp)
app.register_blueprint(reviews_bp)
app.register_blueprint(books_bp)

init_login_manager(app)

@app.route('/')
def index():
    current_page = request.args.get('page', 1, type=int)
    books_per_page = app.config['PER_PAGE']
    
    title = request.args.get('title', '').strip()
    author = request.args.get('author', '').strip()
    genres = request.args.getlist('genres')
    years = request.args.getlist('year')
    volume_from = request.args.get('volume_from', '').strip()
    volume_to = request.args.get('volume_to', '').strip()
    
    books_query = Book.query

    if title:
        books_query = books_query.filter(Book.name.ilike(f"%{title}%"))
    if author:
        books_query = books_query.filter(Book.author.ilike(f"%{author}%"))
    if genres:
        books_query = books_query.join(Book.genres).filter(Genre.id.in_(genres))
    if years:
        books_query = books_query.filter(Book.year.in_(years))
    if volume_from:
        books_query = books_query.filter(Book.volume >= int(volume_from))
    if volume_to:
        books_query = books_query.filter(Book.volume <= int(volume_to))
    
    total_books_count = books_query.count()
    
    books_query = books_query.order_by(desc(Book.year)).limit(books_per_page).offset(books_per_page * (current_page - 1))
    
    books_info = [{'book': book, 'genres': book.genres} for book in books_query]
    
    total_pages = math.ceil(total_books_count / books_per_page)
    
    all_genres = Genre.query.all()
    all_years = db.session.query(Book.year).distinct().order_by(Book.year.desc()).all()
    all_years = [year for year, in all_years]
    
    # Для пагинации
    args = request.args.to_dict()
    args.pop('page', None)
    
    
    return render_template(
        'index.html',
        books=books_info,
        page=current_page,
        page_count=total_pages,
        all_genres=all_genres,
        all_years=all_years,
        args=args
    )


@app.route('/images/<image_id>')
def image(image_id):
    img = db.get_or_404(Image, image_id)
    return send_from_directory(app.config['UPLOAD_FOLDER'],
                               img.stored_file_name)
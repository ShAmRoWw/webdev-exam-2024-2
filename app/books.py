from flask import Blueprint, flash, make_response, redirect, render_template, request, url_for
from flask_login import login_required, current_user
from sqlalchemy import desc
import bleach
import markdown
import os
from models import Book, Genre, Image, Review, db
from auth import check_rights

books_bp = Blueprint('books', __name__, url_prefix='/books')

def params(names_list):
    result = {}
    for name in names_list:
        result[name] = request.form.get(name) or None
    return result

@books_bp.route('/new')
@login_required
@check_rights("create")
def new_book():
    genres_list = db.session.execute(db.select(Genre)).scalars()
    return render_template('books/new.html', genres=genres_list, book={}, new_genres=[])

@books_bp.route('/create', methods=['POST'])
@login_required
@check_rights("create")
def create_book():
    if current_user.can("create"):
        from app import app
        allowed_params = params(app.config['ALLOWED_PARAMETERS'])
        # ALLOWED_PARAMETERS = ["name", "brief_description", "year", "publisher", "author", "volume"]

        sanitized_params = {}
        for param in allowed_params:
            if param in request.form:
                sanitized_value = bleach.clean(request.form[param])
                sanitized_params[param] = sanitized_value

        selected_genres = request.form.getlist('genre_id')
        available_genres = db.session.execute(db.select(Genre)).scalars()
        
        try:
            file = request.files.get('cover_img')
            image_id = None
            if file and file.filename:
                from tools import ImageSaver
                image_saver = ImageSaver(file)
                db_img = image_saver.save_to_db()
                image_id = db_img.id

            new_book = Book(**sanitized_params, image_id=image_id)
            for genre_id in selected_genres:
                genre_instance = db.session.execute(db.select(Genre).filter_by(id=genre_id)).scalar()
                new_book.genres.append(genre_instance)

            db.session.add(new_book)
            db.session.commit()
            
            if file and file.filename:
                image_saver.save_to_system()
            
            flash(f"Книга '{new_book.name}' успешно добавлена", "success")
            return redirect(url_for('books.show', book_id=new_book.id))

        except Exception as e:
            db.session.rollback()
            flash("При сохранении данных возникла ошибка. Проверьте корректность введённых данных {}".format(e), "danger")
            return render_template("books/new.html", genres=available_genres, book=sanitized_params, new_genres=selected_genres)
        
    flash("Недостаточно прав для доступа к странице", "warning")
    return redirect(url_for("index"))


@books_bp.route('/delete_post/<int:book_id>', methods=['POST'])
@login_required
@check_rights('delete')
def delete_post(book_id):
    try:
        book = db.session.query(Book).filter(Book.id == book_id).scalar()
        
        if book:
            book.genres = []
            db.session.query(Review).filter(Review.book_id == book_id).delete()
            
            count_of_images = db.session.query(Book).filter(Book.image_id == book.image_id).count()
            
            db.session.query(Book).filter(Book.id == book_id).delete()
            
            if count_of_images == 1:
                image = db.session.query(Image).filter(Image.id == book.image_id).scalar()
                db.session.query(Image).filter(Image.id == book.image_id).delete()
                db.session.commit()
                
                from app import app
                if os.path.exists(os.path.join(app.config['UPLOAD_FOLDER'], image.stored_file_name)):
                    os.remove(os.path.join(app.config['UPLOAD_FOLDER'], image.stored_file_name))
                # UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'media', 'images')

            else:
                db.session.commit()
            
            flash('Книга успешно удалена', 'success')
        else:
            flash('Книга не найдена', 'danger')
        
        return make_response(redirect(url_for('index')))
    
    except Exception as e:
        db.session.rollback()
        flash("Ошибка при удалении: {}".format(e), 'danger')
        return redirect(url_for('index'))


@books_bp.route('/<int:book_id>/edit', methods=['GET'])
@login_required
@check_rights("edit")
def edit_book(book_id):
    selected_book = db.session.query(Book).filter(Book.id == book_id).scalar()
    all_genres = db.session.execute(db.select(Genre)).scalars()
    current_genres = [str(genre.id) for genre in selected_book.genres]
    return render_template("books/edit.html", genres=all_genres, book=selected_book, new_genres=current_genres)

@books_bp.route('/<int:book_id>/update', methods=['POST'])
@login_required
@check_rights("edit")
def update_book(book_id):
    if current_user.can("edit"):
        from app import app
        allowed_params = params(app.config['ALLOWED_PARAMETERS'])
        # ALLOWED_PARAMETERS = ["name", "brief_description", "year", "publisher", "author", "volume"]
        sanitized_params = {key: bleach.clean(value) for key, value in allowed_params.items()}
        genre_ids = request.form.getlist('genre_id')
        all_genres = db.session.execute(db.select(Genre)).scalars()
        selected_book = db.session.query(Book).filter(Book.id == book_id).scalar()

        try:
            new_genres_list = []
            for genre in genre_ids:
                if int(genre) != 0:
                    new_genre = db.session.execute(db.select(Genre).filter_by(id=genre)).scalar()
                    new_genres_list.append(new_genre)
            selected_book.genres = new_genres_list
            selected_book.name = sanitized_params.get('name')
            selected_book.brief_description = sanitized_params.get('brief_description')
            selected_book.year = sanitized_params.get('year')
            selected_book.publisher = sanitized_params.get('publisher')
            selected_book.author = sanitized_params.get('author')
            selected_book.volume = sanitized_params.get('volume')

            db.session.commit()
            flash(f"Книга '{selected_book.name}' успешно обновлена", "success")
        except Exception as e:
            db.session.rollback()
            flash("При сохранении данных возникла ошибка. Проверьте корректность введённых данных. {}".format(e), "danger")
            return render_template("books/edit.html", genres=all_genres, book=selected_book, new_genres=genre_ids)

        return redirect(url_for('books.show', book_id=selected_book.id))
    flash("Недостаточно прав для доступа к странице", "warning")
    return redirect(url_for("index"))

@books_bp.route('/<int:book_id>')
def show(book_id):
    try:
        selected_book = db.session.query(Book).filter(Book.id == book_id).one_or_none()
        if selected_book is None:
            flash('Книга не найдена', 'danger')
            return redirect(url_for('index'))
        
        selected_book.brief_description = markdown.markdown(selected_book.brief_description)
        
        user_review = None
        all_reviews = []
        
        if current_user.is_authenticated:
            user_review = db.session.query(Review).filter(Review.book_id == book_id,Review.user_id == current_user.id).one_or_none()
            
            if user_review:
                user_review.text = markdown.markdown(user_review.text)
            
            reviews_query = db.select(Review).filter(Review.book_id == book_id,Review.user_id != current_user.id)
        else:
            reviews_query = db.select(Review).filter(Review.book_id == book_id)
        
        all_reviews_result = db.session.execute(reviews_query).scalars()
        
        for review in all_reviews_result:
            all_reviews.append({
                'retrieve_user': review.retrieve_user,
                'mark': review.mark,
                'text': markdown.markdown(review.text)
            })
        
        book_genres = selected_book.genres
        
        return render_template(
            'books/show.html',
            book=selected_book,
            genres=book_genres,
            review=user_review,
            all_reviews=all_reviews
        )
    except Exception as e:
        flash('Ошибка при загрузке данных: {}'.format(e), 'danger')
        return redirect(url_for('index'))

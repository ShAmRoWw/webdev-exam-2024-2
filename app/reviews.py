from flask import Blueprint, render_template, redirect, url_for, flash, request
from flask_login import login_required, current_user
from models import Review, Book, db
from flask import Blueprint
import bleach

bp = Blueprint('reviews', __name__, url_prefix='/reviews')

@bp.route('/<int:book_id>', methods=['GET', 'POST'])
@login_required
def review_post(book_id):
    existing_review = Review.query.filter_by(book_id=book_id, user_id=current_user.id).first()
    current_book = Book.query.get(book_id)

    if existing_review:
        flash("Нельзя добавить более одной рецензии", "warning")
        return redirect(url_for('books.show', book_id=book_id))

    if request.method == 'POST':
        rating = request.form.get('mark')
        review_text = request.form.get('brief_description')

        cleaned_rating = bleach.clean(rating)
        cleaned_text = bleach.clean(review_text)

        try:
            new_review = Review(
                mark=cleaned_rating,
                text=cleaned_text,
                user_id=current_user.id,
                book_id=book_id
            )
            db.session.add(new_review)

            current_book.total_rating += int(cleaned_rating)
            current_book.number_of_ratings += 1

            db.session.commit()
            flash("Рецензия успешно добавлена", "success")
            return redirect(url_for('books.show', book_id=book_id))
        except Exception as e:
            db.session.rollback()
            flash('Ошибка при добавлении рецензии: {}'.format(e), 'danger')
            return redirect(url_for('reviews.review_post', book_id=book_id))

    return render_template('review_post.html', book_id=book_id)

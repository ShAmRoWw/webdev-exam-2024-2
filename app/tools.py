import hashlib
import uuid
import os
from werkzeug.utils import secure_filename
from models import Image, db
from app import app

class ImageSaver:
    def __init__(self, file):
        self.file = file

    def save_to_db(self):
        self.img = self.__find_by_md5_hash()
        if self.img is not None:
            return self.img
        file_name = secure_filename(self.file.filename)
        self.img = Image(
            id=str(uuid.uuid4()),
            filename=file_name,
            mimetype=self.file.mimetype,
            hash_md5=self.md5_hash)
        db.session.add(self.img)
        return self.img
    
    def save_to_system(self):
        if self.img is not None:
            self.file.save(
                os.path.join(app.config['UPLOAD_FOLDER'],
                            self.img.stored_file_name))
        return self.img
    
    # UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'media', 'images')

    def save(self):
        self.img = self.__find_by_md5_hash()
        if self.img is not None:
            return self.img
        file_name = secure_filename(self.file.filename)
        self.img = Image(
            id=str(uuid.uuid4()),
            filename=file_name,
            mimetype=self.file.mimetype,
            hash_md5=self.md5_hash)
        self.file.save(
            os.path.join(app.config['UPLOAD_FOLDER'],
                         self.img.stored_file_name))
        db.session.add(self.img)
        db.session.commit()
        return self.img

    def __find_by_md5_hash(self):
        self.md5_hash = hashlib.md5(self.file.read()).hexdigest()
        self.file.seek(0)
        return db.session.execute(db.select(Image).filter(Image.hash_md5 == self.md5_hash)).scalar()

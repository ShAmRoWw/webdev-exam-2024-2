from flask_login import current_user

class CheckRights:
    def __init__(self, record):
        self.record = record

    def create(self):
        return self._is_admin()

    def delete(self):
        return self._is_admin()

    def edit(self):
        return self._is_admin() or self._is_moderator()

    def _is_admin(self):
        return current_user.has_admin_rights()

    def _is_moderator(self):
        return current_user.has_moderator_rights()

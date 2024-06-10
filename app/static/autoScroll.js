document.addEventListener('DOMContentLoaded', function() {
    // Восстанавливаем позицию прокрутки
    const scrollPosition = localStorage.getItem('scrollPosition');
    if (scrollPosition) {
        window.scrollTo(0, parseInt(scrollPosition, 10));
        localStorage.removeItem('scrollPosition');
    }

    // Сохраняем позицию прокрутки перед переходом по ссылкам пагинации
    document.querySelectorAll('.pagination a').forEach(function(anchor) {
        anchor.addEventListener('click', function() {
            localStorage.setItem('scrollPosition', window.scrollY);
        });
    });
});
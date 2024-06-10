document.addEventListener('DOMContentLoaded', function () {
    const inputDescElement = document.querySelector('#inputDesc');

    if (inputDescElement) {
        const easyMarkdownEditor = new EasyMDE({
            element: inputDescElement,
        });
    }
});

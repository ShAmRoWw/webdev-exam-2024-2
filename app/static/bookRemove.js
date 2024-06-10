document.addEventListener('DOMContentLoaded', function () {
    const modalElement = document.querySelector('#deleteModal');

    if (modalElement) {
        modalElement.addEventListener('show.bs.modal', function (event) {
            const triggerElement = event.relatedTarget;

            if (triggerElement) {
                const dataUrl = triggerElement.getAttribute('data-url');
                const formElement = modalElement.querySelector('form');
                const titleSpan = modalElement.querySelector('.delete-title');
                const dataTitle = triggerElement.getAttribute('data-title');

                if (formElement) {
                    formElement.setAttribute('action', dataUrl);
                }

                if (titleSpan) {
                    titleSpan.textContent = dataTitle;
                }
            }
        });
    }
});

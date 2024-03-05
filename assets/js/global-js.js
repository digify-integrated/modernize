(function($) {
    'use strict';

    $(function() {
        $(document).on('click','#copy-error-message',function() {
            copyToClipboard("error-dialog");
        });
        $(document).on('click','.password-addon',function() {
            if (0 < $(this).siblings("input").length) {
                var inputField = $(this).siblings("input");
                if (inputField.attr("type") === "password") {
                    inputField.attr("type", "text");
                } else {
                    inputField.attr("type", "password");
                }
            }
        });
    });
})(jQuery);

function copyToClipboard(elementID) {
    const element = document.getElementById(elementID);
    const text = element.innerHTML;

    navigator.clipboard.writeText(text)
        .then(() => showNotification('Copy Successful', 'Text copied to clipboard', 'success'))
        .catch((err) => showNotification('Copy Error', err, 'danger'));
}

function showErrorDialog(error){
    const errorDialogElement = document.getElementById('error-dialog');

    if (errorDialogElement) {
        errorDialogElement.innerHTML = error;
        $('#system-error-modal').modal('show');
    }
    else {
        console.error('Error dialog element not found.');
    }    
}

function updateFormSubmitButton(buttonId, disabled, innerHTML) {
    try {
        const submitButton = document.querySelector(`#${buttonId}`);
    
        if (submitButton) {
            submitButton.disabled = disabled;
            submitButton.innerHTML = innerHTML;
        }
        else {
            console.error(`Button with ID '${buttonId}' not found.`);
        }
    }
    catch (error) {
        console.error(error);
    }
}

function disableFormSubmitButton(buttonId) {
    updateFormSubmitButton(buttonId, true, '<div class="spinner-border spinner-border-sm text-light" role="status"><span class="sr-only"></span></div>');
}

function enableFormSubmitButton(buttonId, buttonText) {
    updateFormSubmitButton(buttonId, false, buttonText);
}

function handleSystemError(xhr, status, error) {
    let fullErrorMessage = `XHR status: ${status}, Error: ${error}${xhr.responseText ? `, Response: ${xhr.responseText}` : ''}`;
    showErrorDialog(fullErrorMessage);
}

function showNotification(notificationTitle, notificationMessage, notificationType) {
    const validNotificationTypes = ['success', 'info', 'warning', 'error'];

    if (!validNotificationTypes.includes(notificationType)) {
        console.error('Invalid notification type:', notificationType);
        return;
    }

    const toastrOptions = {
        closeButton: true,
        progressBar: true,
        newestOnTop: true,
        preventDuplicates: false,
        positionClass: 'toast-top-center',
        timeOut: 3000,
        showMethod: 'fadeIn',
        hideMethod: 'fadeOut'
    };

    toastr.options = toastrOptions;
    toastr[notificationType](notificationMessage, notificationTitle);
}
  
function setNotification(notificationTitle, notificationMessage, notificationType){
    sessionStorage.setItem('notificationTitle', notificationTitle);
    sessionStorage.setItem('notificationMessage', notificationMessage);
    sessionStorage.setItem('notificationType', notificationType);
}
  
function checkNotification() {
    const storageKeys = ['notificationTitle', 'notificationMessage', 'notificationType'];
    const { notificationTitle, notificationMessage, notificationType } = sessionStorage;
    
    if (storageKeys.every(key => sessionStorage.hasOwnProperty(key))) {
        storageKeys.forEach(key => sessionStorage.removeItem(key));
        showNotification({ notificationTitle, notificationMessage, notificationType });
    }
}
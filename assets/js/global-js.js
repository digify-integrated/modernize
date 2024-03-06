(function($) {
    'use strict';

    $(function() {
        checkNotification();
        
        $(document).on('click','#copy-error-message',function() {
            copyToClipboard('error-dialog');
        });

        $(document).on('click','.password-addon',function() {
            if (0 < $(this).siblings('input').length) {
                var inputField = $(this).siblings('input');
                var eyeIcon = $(this).find('i');
        
                if (inputField.attr('type') === 'password') {
                    inputField.attr('type', 'text');
                    eyeIcon.removeClass('ti-eye').addClass('ti-eye-off');
                }
                else {
                    inputField.attr('type', 'password');
                    eyeIcon.removeClass('ti-eye-off').addClass('ti-eye');
                }
            }
        });
    });
})(jQuery);

function handleColorTheme(e) {
    $('html').attr('data-color-theme', e);
    $(e).prop('checked', !0);
}

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

function updateFormSubmitButton(buttonId, disabled) {
    try {
        const submitButton = document.querySelector(`#${buttonId}`);
    
        if (submitButton) {
            submitButton.disabled = disabled;
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
    updateFormSubmitButton(buttonId, true);
}

function enableFormSubmitButton(buttonId) {
    updateFormSubmitButton(buttonId, false);
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
        timeOut: 5000,
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
    const { 
        'notificationTitle': notificationTitle, 
        'notificationMessage': notificationMessage, 
        'notificationType': notificationType 
    } = sessionStorage;
    
    if (notificationTitle && notificationMessage && notificationType) {
        sessionStorage.removeItem('notificationTitle');
        sessionStorage.removeItem('notificationMessage');
        sessionStorage.removeItem('notificationType');

        showNotification(notificationTitle, notificationMessage, notificationType);
    }
}
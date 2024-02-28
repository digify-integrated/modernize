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
    let fullErrorMessage = `XHR status: ${status}, Error: ${error}`;

    if (xhr.responseText) {
        fullErrorMessage += `, Response: ${xhr.responseText}`;
    }

    showErrorDialog(fullErrorMessage);
}

function showNotification(notificationTitle, notificationMessage, notificationType) {
    const validNotificationTypes = ['success', 'info', 'warning', 'error'];

    if (!validNotificationTypes.includes(notificationType)) {
        console.error('Invalid notification type:', notificationType);
        return;
    }

    const isLongDuration = ['error', 'warning'].includes(notificationType);
    const duration = isLongDuration ? 6000 : 4000;

    const toastrOptions = {
        closeButton: true,
        progressBar: true,
        newestOnTop: true,
        preventDuplicates: false,
        positionClass: 'toast-top-right',
        timeOut: duration,
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
    
    const { 
        notificationTitle, 
        notificationMessage, 
        notificationType 
    } = sessionStorage;

    const hasNotificationData = storageKeys.every(key => sessionStorage.hasOwnProperty(key));

    if (hasNotificationData) {
        storageKeys.forEach(key => sessionStorage.removeItem(key));
        showNotification(notificationTitle, notificationMessage, notificationType);
    }
}
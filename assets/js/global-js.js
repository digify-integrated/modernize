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
            console.error(`Button with ID '${buttonId}' not found`);
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

function handleAuthenticationError(xhr, status, error) {
    let fullErrorMessage = `XHR status: ${status}, Error: ${error}`;

    if (xhr.responseText) {
        fullErrorMessage += `, Response: ${xhr.responseText}`;
    }

    showErrorDialog(fullErrorMessage);
}

function showNotification(notificationTitle, notificationMessage, notificationType) {
    const notificationIcons = {
        success: './assets/images/notification/ok-48.png',
        danger: './assets/images/notification/high_priority-48.png',
        info: './assets/images/notification/survey-48.png',
        warning: './assets/images/notification/medium_priority-48.png',
        default: './assets/images/notification/clock-48.png'
    };
  
    const icon = notificationIcons[notificationType] || notificationIcons.default;
    const duration = (notificationType === 'danger' || notificationType === 'warning') ? 6000 : 4000;
  
    notifier.show(notificationTitle, notificationMessage, notificationType, icon, duration);
}
  
function setNotification(notificationTitle, notificationMessage, notificationType){
    sessionStorage.setItem('notificationTitle', notificationTitle);
    sessionStorage.setItem('notificationMessage', notificationMessage);
    sessionStorage.setItem('notificationType', notificationType);
}
  
function checkNotification(){
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
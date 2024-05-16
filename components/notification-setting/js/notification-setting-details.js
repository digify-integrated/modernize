(function($) {
    'use strict';

    $(function() {
        displayDetails('get notification setting details');

        if($('#notification-setting-form').length){
            notificationSettingForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get notification setting details');
        });

        $(document).on('click','#delete-notification-setting',function() {
            const notification_setting_id = $('#notification-setting-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete notification setting';
    
            Swal.fire({
                title: 'Confirm User Account Deletion',
                text: 'Are you sure you want to delete this notification setting?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Delete',
                cancelButtonText: 'Cancel',
                customClass: {
                    confirmButton: 'btn btn-danger mt-2',
                    cancelButton: 'btn btn-secondary ms-2 mt-2'
                },
                buttonsStyling: !1
            }).then(function(result) {
                if (result.value) {
                    $.ajax({
                        type: 'POST',
                        url: 'components/notification-setting/controller/notification-setting-controller.php',
                        dataType: 'json',
                        data: {
                            notification_setting_id : notification_setting_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification(response.title, response.message, response.messageType);
                                window.location = page_link;
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = page_link;
                                }
                                else {
                                    showNotification(response.title, response.message, response.messageType);
                                }
                            }
                        },
                        error: function(xhr, status, error) {
                            var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                            if (xhr.responseText) {
                                fullErrorMessage += `, Response: ${xhr.responseText}`;
                            }
                            showErrorDialog(fullErrorMessage);
                        }
                    });
                    return false;
                }
            });
        });

        $(document).on('change','#system-notification',function() {
            const notification_setting_id = $('#notification-setting-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            var checkbox = document.getElementById('system-notification');
            var transaction = (checkbox).checked ? 'enable system notification channel' : 'disable system notification channel';

            $.ajax({
                type: 'POST',
                url: 'components/notification-setting/controller/notification-setting-controller.php',
                data: {
                    notification_setting_id : notification_setting_id,
                    transaction : transaction
                },
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = page_link;
                        }
                        else {
                            showNotification(response.title, response.message, response.messageType);
                        }
                    }
                },
                error: function(xhr, status, error) {
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                }
            });
        });

        $(document).on('change','#email-notification',function() {
            const notification_setting_id = $('#notification-setting-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            var checkbox = document.getElementById('email-notification');
            var transaction = (checkbox).checked ? 'enable email notification channel' : 'disable email notification channel';

            $.ajax({
                type: 'POST',
                url: 'components/notification-setting/controller/notification-setting-controller.php',
                data: {
                    notification_setting_id : notification_setting_id,
                    transaction : transaction
                },
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = page_link;
                        }
                        else {
                            showNotification(response.title, response.message, response.messageType);
                        }
                    }
                },
                error: function(xhr, status, error) {
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                }
            });
        });

        $(document).on('change','#sms-notification',function() {
            const notification_setting_id = $('#notification-setting-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            var checkbox = document.getElementById('sms-notification');
            var transaction = (checkbox).checked ? 'enable sms notification channel' : 'disable sms notification channel';

            $.ajax({
                type: 'POST',
                url: 'components/notification-setting/controller/notification-setting-controller.php',
                data: {
                    notification_setting_id : notification_setting_id,
                    transaction : transaction
                },
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = page_link;
                        }
                        else {
                            showNotification(response.title, response.message, response.messageType);
                        }
                    }
                },
                error: function(xhr, status, error) {
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                }
            });
        });

        if($('#log-notes-offcanvas').length && $('#view-log-notes').length){
            $(document).on('click','#view-log-notes',function() {
                const notification_setting_id = $('#notification-setting-id').text();

                logNotes('notification_setting', notification_setting_id);
            });
        }
    });
})(jQuery);

function notificationSettingForm(){
    $('#notification-setting-form').validate({
        rules: {
            notification_setting_name: {
                required: true
            },
            notification_setting_description: {
                required: true
            }
        },
        messages: {
            notification_setting_name: {
                required: 'Please enter the display name'
            },
            notification_setting_description: {
                required: 'Please enter the description'
            }
        },
        errorPlacement: function (error, element) {
            showNotification('Attention Required: Error Found', error, 'error', 1500);
        },
        highlight: function(element) {
            var inputElement = $(element);
            if (inputElement.hasClass('select2-hidden-accessible')) {
                inputElement.next().find('.select2-selection__rendered').addClass('is-invalid');
            }
            else {
                inputElement.addClass('is-invalid');
            }
        },
        unhighlight: function(element) {
            var inputElement = $(element);
            if (inputElement.hasClass('select2-hidden-accessible')) {
                inputElement.next().find('.select2-selection__rendered').removeClass('is-invalid');
            }
            else {
                inputElement.removeClass('is-invalid');
            }
        },
        submitHandler: function(form) {
            const notification_setting_id = $('#notification-setting-id').text();
            const transaction = 'update notification setting';
          
            $.ajax({
                type: 'POST',
                url: 'components/notification-setting/controller/notification-setting-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction +'&notification_setting_id=' + notification_setting_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get notification setting details');
                        $('#notification-setting-modal').modal('hide');
                    }
                    else {
                        if (response.isInactive || response.notExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else {
                            showNotification(response.title, response.message, response.messageType);
                        }
                    }
                },
                error: function(xhr, status, error) {
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                },
                complete: function() {
                    enableFormSubmitButton('submit-data');
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get notification setting details':
            var notification_setting_id = $('#notification-setting-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/notification-setting/controller/notification-setting-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    notification_setting_id : notification_setting_id, 
                    transaction : transaction
                },
                success: function(response) {
                    if (response.success) {
                        $('#notification_setting_name').val(response.notificationSettingName);
                        $('#notification_setting_description').val(response.notificationSettingDescription);
                        
                        $('#notification_setting_name_summary').text(response.notificationSettingName);
                        $('#notification_setting_description_summary').text(response.notificationSettingDescription);

                        document.getElementById('system-notification').checked = response.systemNotification === 1;
                        document.getElementById('email-notification').checked = response.emailNotification === 1;
                        document.getElementById('sms-notification').checked = response.smsNotification === 1;
                    } 
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = page_link;
                        }
                        else {
                            showNotification(response.title, response.message, response.messageType);
                        }
                    }
                },
                error: function(xhr, status, error) {
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                }
            });
            break;
    }
}
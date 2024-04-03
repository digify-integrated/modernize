(function($) {
    'use strict';

    $(function() {
        if($('#user-account-form').length){
            userAccountForm();
        }

        $(document).on('click','#discard-create',function() {
            discardCreate('user-account.php');
        });
    });
})(jQuery);

function userAccountForm(){
    $('#user-account-form').validate({
        rules: {
            file_as: {
                required: true
            },
            email: {
                required: true
            },
            password: {
                required: true,
                password_strength: true
            }
        },
        messages: {
            file_as: {
                required: 'Please enter the display name'
            },
            email: {
                required: 'Please enter the email'
            },
            password: {
                required: 'Please enter the password'
            }
        },
        errorPlacement: function (error, element) {
            showNotification('Form Validation Error', error, 'error', 1500);
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
            const transaction = 'add menu group';
          
            $.ajax({
                type: 'POST',
                url: 'components/user-account/controller/user-account-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
                        window.location = 'user-account.php?id=' + response.userAccountID;
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
$(document).ready(function () {  
    $('#signin-form').validate({
        rules: {
            username: {
                required: true,
            },
            password: {
                required: true
            }
        },
        messages: {
            username: {
                required: 'Please enter your username',
            },
            password: {
                required: 'Please enter your password'
            }
        },
        errorPlacement: function (error, element) {
            if (element.hasClass('select2') || element.hasClass('modal-select2') || element.hasClass('offcanvas-select2')) {
                error.insertAfter(element.next('.select2-container'));
            }
            else if (element.parent('.input-group').length) {
                error.insertAfter(element.parent());
            }
            else {
                error.insertAfter(element);
            }
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
            const transaction = 'authenticate';
    
            $.ajax({
                type: 'POST',
                url: 'controller/user-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('signin');
                },
                success: function(response) {
                    if (response.success) {
                        if (response.emailVerification) {
                            window.location.href = 'email-verification.php?id=' + response.encryptedUserID;
                        }
                        else if (response.twoFactorAuth) {
                            window.location.href = 'otp-verification.php?id=' + response.encryptedUserID;
                        }
                        else {
                            window.location.href = 'dashboard.php';
                        }
                    } 
                    else {
                        showNotification('Authentication Error', response.message, 'danger');
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
                    enableFormSubmitButton('signin', 'Login');
                }
            });
    
            return false;
        }
    });
});
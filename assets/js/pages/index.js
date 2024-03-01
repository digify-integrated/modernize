$(document).ready(function () {  
    $('#signin-form').validate({
        rules: {
            email: {
                required: true,
            },
            password: {
                required: true
            }
        },
        messages: {
            email: {
                required: 'Please enter your email',
            },
            password: {
                required: 'Please enter your password'
            }
        },
        errorPlacement: function (error, element) {
            const isSelect2 = element.hasClass('select2') || element.hasClass('modal-select2') || element.hasClass('offcanvas-select2');
            const insertAfterElement = isSelect2 ? element.next('.select2-container') : (element.parent('.input-group').length ? element.parent() : element);
        
            error.insertAfter(insertAfterElement);
        },
        highlight: function (element) {
            const inputElement = $(element);
            const isSelect2 = inputElement.hasClass('select2-hidden-accessible');
        
            if (isSelect2) {
                inputElement.next().find('.select2-selection__rendered').addClass('is-invalid');
            }
            else {
                inputElement.addClass('is-invalid');
            }
        },
        unhighlight: function (element) {
            const inputElement = $(element);
            const isSelect2 = inputElement.hasClass('select2-hidden-accessible');
        
            if (isSelect2) {
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
                url: 'components/authentication/controller/authentication-controller.php',
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
                        showNotification(response.title, response.message, response.messageType);
                    }
                },
                error: function(xhr, status, error) {
                    handleSystemError(xhr, status, error);
                },
                complete: function() {
                    enableFormSubmitButton('signin', 'Login');
                }
            });
    
            return false;
        }
    });
});
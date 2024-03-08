$(document).ready(function () {  
    $('#password-reset-form').validate({
        rules: {
            new_password: {
                required: true,
                password_strength: true
            },
            confirm_password: {
                required: true,
                equalTo: '#new_password'
            }
          },
        messages: {
            new_password: {
                required: 'Please enter password'
            },
            confirm_password: {
                required: 'Please re-enter your password for confirmation',
                equalTo: 'The passwords you entered do not match'
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
            const transaction = 'password reset';
    
            $.ajax({
                type: 'POST',
                url: 'components/authentication/controller/authentication-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('reset');
                },
                success: function(response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
                        
                        window.location.href = 'index.php';
                    } 
                    else {
                        if (response.passwordExist) {
                            showNotification(response.title, response.message, response.messageType);
                        }
                        else{
                            setNotification(response.title, response.message, response.messageType);
                            window.location.href = 'index.php';
                        }
                    }
                },
                error: function(xhr, status, error) {
                    handleSystemError(xhr, status, error);
                },
                complete: function() {
                    enableFormSubmitButton('reset');
                }
            });
    
            return false;
        }
    });
});
$(document).ready(function () {
    otpForm();
    
    $('.otp-input').on('input', function() {
        var maxLength = parseInt($(this).attr('maxlength'));
        var currentLength = $(this).val().length;

        if (currentLength === maxLength) {
            $(this).next('.otp-input').focus();
        }
    });

    $('.otp-input').on('paste', function(e) {
        e.preventDefault();
        
        var pastedData = (e.originalEvent || e).clipboardData.getData('text/plain');
        
        var filteredData = pastedData.replace(/[^a-zA-Z0-9]/g, '');

        for (var i = 0; i < filteredData.length; i++) {
            if (i < 6) {
                $('#otp_code_' + (i + 1)).val(filteredData.charAt(i));
            }
        }
    });

    $('.otp-input').on('keydown', function(e) {
        if (e.which === 8 && $(this).val().length === 0) {
            $(this).prev('.otp-input').focus();
        }
    });

    $('#resend-link').on('click', function(e) {
        resetCountdown(60);
    });
});

function otpForm(){
    $('#otp-form').validate({
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
            const transaction = 'otp verification';
    
            $.ajax({
                type: 'POST',
                url: 'components/authentication/controller/authentication-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('verify');
                },
                success: function(response) {
                    if (response.success) {
                        window.location.href = 'dashboard.php';
                    } 
                    else {
                        if(response.otpMaxFailedAttempt || response.incorrectOTPCode || response.expiredOTP){
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
                    enableFormSubmitButton('verify');
                }
            });
    
            return false;
        }
    });
}

function startCountdown(countdownValue) {
    $('#countdown').removeClass('d-none');
    $('#resend-link').addClass('d-none');

    countdownTimer = setInterval(function () {
        document.getElementById('timer').innerHTML = countdownValue;
        countdownValue--;

        if (countdownValue < 0) {
            clearInterval(countdownTimer);
            $('#countdown').addClass('d-none');
            $('#resend-link').removeClass('d-none');
        }
    }, 1000);
}

function resetCountdown(countdownValue) {
    const user_id = $('#user_id').val();
    const transaction = 'resend otp';

    $.ajax({
        type: 'POST',
        url: 'components/authentication/controller/authentication-controller.php',
        dataType: 'json',
        data: {
            user_id : user_id, 
            transaction : transaction
        },
        beforeSend: function() {
            $('#countdown').removeClass('d-none');
            $('#resend-link').addClass('d-none');

            document.getElementById('timer').innerHTML = countdownValue;

            startCountdown(countdownValue);
        },
        success: function (response) {
            if (!response.success) {
                window.location.href = 'index.php';
                setNotification(response.title, response.message, response.messageType);
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
}
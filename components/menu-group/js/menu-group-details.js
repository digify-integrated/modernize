(function($) {
    'use strict';

    $(function() {
        displayDetails('get menu group details');

        if($('#menu-group-form').length){
            menuGroupForm();
        }

        if($('#log-notes-offcanvas').length){
            const menu_group_id = $('#menu-group-id').text();

            logNotes('menu_group', menu_group_id);
        }
    });
})(jQuery);

function menuGroupForm(){
    $('#menu-group-form').validate({
        rules: {
            menu_group_name: {
                required: true
            },
            order_sequence: {
                required: true
            }
        },
        messages: {
            menu_group_name: {
                required: 'Please enter the display name'
            },
            order_sequence: {
                required: 'Please enter the order sequence'
            }
        },
        errorPlacement: function (error, element) {
            if (element.hasClass('select2') || element.hasClass('modal-select2')) {
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
            const menu_group_id = $('#menu-group-id').text();
            const transaction = 'update menu group';
          
            $.ajax({
                type: 'POST',
                url: 'components/menu-group/controller/menu-group-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&menu_group_id=' + menu_group_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get menu group details');
                        $('#menu-group-modal').modal('hide');
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
        case 'get menu group details':
            var menu_group_id = $('#menu-group-id').text();
            
            $.ajax({
                url: 'components/menu-group/controller/menu-group-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    menu_group_id : menu_group_id, 
                    transaction : transaction
                },
                success: function(response) {
                    if (response.success) {
                        $('#menu_group_name').val(response.menuGroupName);
                        $('#order_sequence').val(response.orderSequence);
                        
                        $('#menu_group_name_summary').text(response.menuGroupName);
                        $('#order_sequence_summary').text(response.orderSequence);
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
                }
            });
            break;
    }
}
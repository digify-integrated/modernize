(function($) {
    'use strict';

    $(function() {
        if($('#menu-item-form').length){
            menuItemForm();
        }

        $(document).on('click','#discard-create',function() {
            discardCreate('menu-item.php');
        });

        $('#menu_group').select2({
            ajax: {
                data: {'type' : 'menu group options'},
                method : 'POST',
                url: './components/menu-group/view/_menu_group_generation.php',
                dataType: 'json',
                minimumInputLength: 1   ,
                processResults: function (data, params) {
                    if (!params.term || params.term.trim() === '') {
                        return {
                            results: data
                        };
                    }

                    var filteredData = $.map(data, function (item) {
                        if (item.text.toLowerCase().indexOf(params.term.toLowerCase()) !== -1) {
                            return {
                                id: item.id,
                                text: item.text
                            };
                        }
                    });
                    
                    return {
                        results: filteredData
                    };
                },
            }
        }).on('change', function (e) {
            $(this).valid()
        });

        $('#parent_id').select2({
            ajax: {
                data: {'type' : 'menu item options'},
                method : 'POST',
                url: './components/menu-item/view/_menu_item_generation.php',
                dataType: 'json',
                minimumInputLength: 1   ,
                processResults: function (data, params) {
                    if (!params.term || params.term.trim() === '') {
                        return {
                            results: data
                        };
                    }

                    var filteredData = $.map(data, function (item) {
                        if (item.text.toLowerCase().indexOf(params.term.toLowerCase()) !== -1) {
                            return {
                                id: item.id,
                                text: item.text
                            };
                        }
                    });
                    
                    return {
                        results: filteredData
                    };
                },
            }
        }).on('change', function (e) {
            $(this).valid()
        });
    });
})(jQuery);

function menuItemForm(){
    $('#menu-item-form').validate({
        rules: {
            menu_item_name: {
                required: true
            },
            menu_group: {
                required: true
            },
            order_sequence: {
                required: true
            }
        },
        messages: {
            menu_item_name: {
                required: 'Please enter the display name'
            },
            menu_group: {
                required: 'Please choose the menu group'
            },
            order_sequence: {
                required: 'Please enter the order sequence'
            }
        },
        errorPlacement: function (error, element) {
            showNotification('Form Validation Error', error, 'error', 1500);
        },
        highlight: function(element) {
            var inputElement = $(element);
            if (inputElement.hasClass('select2-hidden-accessible')) {
                inputElement.next().find('.select2-selection').addClass('is-invalid');
            }
            else {
                inputElement.addClass('is-invalid');
            }
        },
        unhighlight: function(element) {
            var inputElement = $(element);
            if (inputElement.hasClass('select2-hidden-accessible')) {
                inputElement.next().find('.select2-selection').removeClass('is-invalid');
            }
            else {
                inputElement.removeClass('is-invalid');
            }
        },
        submitHandler: function(form) {
            const transaction = 'add menu item';
          
            $.ajax({
                type: 'POST',
                url: 'components/menu-item/controller/menu-item-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
                        window.location = 'menu-item.php?id=' + response.menuItemID;
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
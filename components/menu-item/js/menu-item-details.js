(function($) {
    'use strict';

    $(function() {
        displayDetails('get menu item details');

        if($('#menu-item-form').length){
            menuItemForm();
        }

        $(document).on('click','#delete-menu-item',function() {
            const menu_item_id = $('#menu-item-id').text();
            const transaction = 'delete menu item';
    
            Swal.fire({
                title: 'Confirm Menu Item Deletion',
                text: 'Are you sure you want to delete this menu item?',
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
                        url: 'components/menu-item/controller/menu-item-controller.php',
                        dataType: 'json',
                        data: {
                            menu_item_id : menu_item_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification('Delete Menu Item Success', 'The menu item has been deleted successfully.', 'success');
                                window.location = 'menu-item.php';
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'menu-item.php';
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

        $('#menu_group').select2({
            dropdownParent: $('#menu-item-modal'),
            ajax: {
                data: {'type' : 'menu group options'},
                method : 'POST',
                url: './components/menu-group/view/_menu_group_generation.php',
                dataType: 'json',
                minimumInputLength: 1,
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
            $(this).valid();
        });

        $('#parent_id').select2({
            dropdownParent: $('#menu-item-modal'),
            ajax: {
                data: {'type' : 'menu item options'},
                method : 'POST',
                url: './components/menu-item/view/_menu_item_generation.php',
                dataType: 'json',
                minimumInputLength: 1,
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
            $(this).valid();
        });

        if($('#log-notes-offcanvas').length && $('#view-log-notes').length){
            $(document).on('click','#view-log-notes',function() {
                const menu_item_id = $('#menu-item-id').text();

                logNotes('menu_item', menu_item_id);
            });
        }
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
            const transaction = 'update menu item';
          
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

function displayDetails(transaction){
    switch (transaction) {
        case 'get menu item details':
            var menu_item_id = $('#menu-item-id').text();
            
            $.ajax({
                url: 'components/menu-item/controller/menu-item-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    menu_item_id : menu_item_id, 
                    transaction : transaction
                },
                success: function(response) {
                    if (response.success) {
                        $('#menu_item_name').val(response.menuItemName);
                        $('#order_sequence').val(response.orderSequence);
                        
                        $('#menu_group').val(5).trigger('change');
                        
                        $('#menu_item_name_summary').text(response.menuItemName);
                        $('#menu_group_summary').text(response.menuGroupName);
                        $('#parent_menu_item_summary').text(response.parentName);
                        $('#menu_item_url_summary').text(response.menuItemURL);
                        $('#menu_item_icon_summary').text(response.menuItemIcon);
                        $('#order_sequence_summary').text(response.orderSequence);
                    } 
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'menu-item.php';
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
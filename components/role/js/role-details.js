(function($) {
    'use strict';

    $(function() {
        displayDetails('get role details');
        generateDropdownOptions('role menu item dual listbox options');

        if($('#role-form').length){
            roleForm();
        }

        if($('#role-permission-assignment-form').length){
            rolePermissionAssignmentForm();
        }

        if($('#assigned-role-permission-table').length){
            assignedRolePermissionTable('#assigned-role-permission-table');
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get role details');
        });

        $(document).on('click','#assign-role-permission',function() {
            generateDropdownOptions('role menu item dual listbox options');
        });

        $(document).on('click','#delete-role',function() {
            const role_id = $('#role-id').text();
            const transaction = 'delete role';
    
            Swal.fire({
                title: 'Confirm Role Deletion',
                text: 'Are you sure you want to delete this role?',
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
                        url: 'components/role/controller/role-controller.php',
                        dataType: 'json',
                        data: {
                            role_id : role_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification('Delete Role Success', 'The role has been deleted successfully.', 'success');
                                window.location = 'role.php';
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'role.php';
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

        if($('#log-notes-offcanvas').length && $('#view-log-notes').length){
            $(document).on('click','#view-log-notes',function() {
                const role_id = $('#role-id').text();

                logNotes('role', role_id);
            });
        }
    });
})(jQuery);

function roleForm(){
    $('#role-form').validate({
        rules: {
            role_name: {
                required: true
            },
            role_description: {
                required: true
            }
        },
        messages: {
            role_name: {
                required: 'Please enter the display name'
            },
            role_description: {
                required: 'Please enter the role description'
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
            const role_id = $('#role-id').text();
            const transaction = 'update role';
          
            $.ajax({
                type: 'POST',
                url: 'components/role/controller/role-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&role_id=' + role_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get role details');
                        $('#role-modal').modal('hide');
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'role.php';
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

function rolePermissionAssignmentForm(){
    $('#role-permission-assignment-form').validate({
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
            const role_id = $('#role-id').text();
            const transaction = 'assign role permission';
          
            $.ajax({
                type: 'POST',
                url: 'components/role/controller/role-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&role_id=' + role_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        reloadDatatable('#assigned-role-permission-table');
                        $('#role-permission-assignment-modal').modal('hide');
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'role.php';
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
        case 'get role details':
            var role_id = $('#role-id').text();
            
            $.ajax({
                url: 'components/role/controller/role-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    role_id : role_id, 
                    transaction : transaction
                },
                success: function(response) {
                    if (response.success) {
                        $('#role_name').val(response.roleName);
                        $('#role_description').val(response.roleDescription);
                        
                        $('#role_name_summary').text(response.roleName);
                        $('#role_description_summary').text(response.roleDescription);
                    } 
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'role.php';
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
                complete: function(){
                    resetModalForm('role-form');
                }
            });
            break;
    }
}

function assignedRolePermissionTable(datatable_name, buttons = false, show_all = false){
    const role_id = $('#role-id').text();
    const type = 'assigned role permission table';
    var settings;

    const column = [ 
        { 'data' : 'MENU_ITEM' },
        { 'data' : 'READ_ACCESS' },
        { 'data' : 'CREATE_ACCESS' },
        { 'data' : 'WRITE_ACCESS' },
        { 'data' : 'DELETE_ACCESS' },
        { 'data' : 'ACTION' }
    ];

    const column_definition = [
        { 'width': '30%', 'aTargets': 0 },
        { 'width': '15%', 'aTargets': 1 },
        { 'width': '15%', 'aTargets': 2 },
        { 'width': '15%', 'aTargets': 3 },
        { 'width': '15%', 'aTargets': 4 },
        { 'width': '10%','bSortable': false, 'aTargets': 5 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/role/view/_role_generation.php',
            'method' : 'POST',
            'dataType': 'json',
            'data': {'type' : type, 'role_id' : role_id},
            'dataSrc' : '',
            'error': function(xhr, status, error) {
                var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                if (xhr.responseText) {
                    fullErrorMessage += `, Response: ${xhr.responseText}`;
                }
                showErrorDialog(fullErrorMessage);
            }
        },
        'order': [[ 1, 'asc' ]],
        'columns' : column,
        'fnDrawCallback': function( oSettings ) {
            readjustDatatableColumn();
        },
        'columnDefs': column_definition,
        'lengthMenu': length_menu,
        'language': {
            'emptyTable': 'No data found',
            'searchPlaceholder': 'Search...',
            'search': '',
            'loadingRecords': 'Just a moment while we fetch your data...'
        },
    };

    if (buttons) {
        settings.dom = "<'row'<'col-sm-6'f><'col-sm-6 text-right'B>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>";
        settings.buttons = ['csv', 'excel', 'pdf'];
    }

    destroyDatatable(datatable_name);

    $(datatable_name).dataTable(settings);
}

function generateDropdownOptions(type){
    switch (type) {
        case 'role menu item dual listbox options':
            const role_id = $('#role-id').text();

            $.ajax({
                url: 'components/menu-item/view/_menu_item_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    role_id : role_id
                },
                success: function(response) {
                    var select = document.getElementById('menu_item_id');

                    select.options.length = 0;

                    response.forEach(function(opt) {
                        var option = new Option(opt.text, opt.id);
                        select.appendChild(option);
                    });
                },
                error: function(xhr, status, error) {
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                },
                complete: function(){
                    if($('#menu_item_id').length){
                        $('#menu_item_id').bootstrapDualListbox({
                            nonSelectedListLabel: 'Non-selected',
                            selectedListLabel: 'Selected',
                            preserveSelectionOnMove: 'moved',
                            moveOnSelect: false,
                        });

                        $('#menu_item_id').bootstrapDualListbox('refresh', true);

                        initializeDualListBoxIcon();
                    }
                }
            });
            break;
    }
}
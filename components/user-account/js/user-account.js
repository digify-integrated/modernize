(function($) {
    'use strict';

    $(function() {
        if($('#user-account-table').length){
            userAccountTable('#user-account-table');
        }

        $(document).on('click','.delete-user-account',function() {
            const user_account_id = $(this).data('user-account-id');
            const transaction = 'delete user account';
    
            Swal.fire({
                title: 'Confirm User Account Deletion',
                text: 'Are you sure you want to delete this user account?',
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
                        url: 'components/user-account/controller/user-account-controller.php',
                        dataType: 'json',
                        data: {
                            user_account_id : user_account_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification('Delete User Account Success', 'The user account has been deleted successfully.', 'success');
                                reloadDatatable('#user-account-table');
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    reloadDatatable('#user-account-table');
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

        $(document).on('click','#delete-user-account',function() {
            let user_account_id = [];
            const transaction = 'delete multiple user account';

            $('.datatable-checkbox-children').each((index, element) => {
                if ($(element).is(':checked')) {
                    user_account_id.push(element.value);
                }
            });
    
            if(user_account_id.length > 0){
                Swal.fire({
                    title: 'Confirm Multiple User Accounts Deletion',
                    text: 'Are you sure you want to delete these user accounts?',
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
                            url: 'components/user-account/controller/user-account-controller.php',
                            dataType: 'json',
                            data: {
                                user_account_id: user_account_id,
                                transaction : transaction
                            },
                            success: function (response) {
                                if (response.success) {
                                    showNotification('Delete User Account Success', 'The selected user accounts have been deleted successfully.', 'success');
                                    reloadDatatable('#user-account-table');
                                }
                                else {
                                    if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
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
                            complete: function(){
                                toggleHideActionDropdown();
                            }
                        });
                        
                        return false;
                    }
                });
            }
            else{
                showNotification('Deletion Multiple User Account Error', 'Please select the user accounts you wish to delete.', 'danger');
            }
        });

        $(document).on('click','#apply-filter',function() {
            userAccountTable('#user-account-table');
            $('#filter-offcanvas').offcanvas('hide');
        });
    });
})(jQuery);

function userAccountTable(datatable_name, buttons = false, show_all = false){
    toggleHideActionDropdown();

    const type = 'user account table';
    var filter_by_user_account_status = $('input[name="filter-user-account-status"]:checked').val();
    var filter_by_user_account_lock_status = $('input[name="filter-user-account-lock-status"]:checked').val();
    var filter_by_password_expiry_date = $('#filter-password-expiry-date').val();
    var filter_last_connection_date = $('#filter-last-connection-date').val();
    var settings;

    const column = [ 
        { 'data' : 'CHECK_BOX' },
        { 'data' : 'USER_ACCOUNT' },
        { 'data' : 'USER_ACCOUNT_STATUS' },
        { 'data' : 'LOCK_STATUS' },
        { 'data' : 'PASSWORD_EXPIRY_DATE' },
        { 'data' : 'LAST_CONNECTION_DATE' },
        { 'data' : 'ACTION' }
    ];

    const column_definition = [
        { 'width': '1%','bSortable': false, 'aTargets': 0 },
        { 'width': 'auto', 'aTargets': 1 },
        { 'width': 'auto', 'aTargets': 2 },
        { 'width': 'auto', 'aTargets': 3 },
        { 'width': 'auto', 'aTargets': 4 },
        { 'width': 'auto', 'aTargets': 5 },
        { 'width': '15%', 'bSortable': false, 'aTargets': 6 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/user-account/view/_user_account_generation.php',
            'method' : 'POST',
            'dataType': 'json',
            'data': {
                'type' : type, 
                'filter_by_user_account_status' : filter_by_user_account_status, 
                'filter_by_user_account_lock_status' : filter_by_user_account_lock_status,
                'filter_by_password_expiry_date' : filter_by_password_expiry_date,
                'filter_last_connection_date' : filter_last_connection_date
            },
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
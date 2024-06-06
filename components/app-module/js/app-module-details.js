(function($) {
    'use strict';

    $(function() {
        displayDetails('get app module details');

        if($('#app-module-form').length){
            appModuleForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get app module details');
        });

        $(document).on('click','#delete-app-module',function() {
            const app_module_id = $('#app-module-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'delete app module';
    
            Swal.fire({
                title: 'Confirm App Module Deletion',
                text: 'Are you sure you want to delete this app module?',
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
                        url: 'components/app-module/controller/app-module-controller.php',
                        dataType: 'json',
                        data: {
                            app_module_id : app_module_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification(response.title, response.message, response.messageType);
                                window.location = page_link;
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = page_link;
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
                const app_module_id = $('#app-module-id').text();

                logNotes('app_module', app_module_id);
            });
        }

        if($('#internal-notes').length){
            const app_module_id = $('#app-module-id').text();

            internalNotes('app_module', app_module_id);
        }

        if($('#internal-notes-form').length){
            const app_module_id = $('#app-module-id').text();

            internalNotesForm('app_module', app_module_id);
        }
    });
})(jQuery);

function appModuleForm(){
    $('#app-module-form').validate({
        rules: {
            app_module_name: {
                required: true
            },
            app_module_description: {
                required: true
            },
            order_sequence: {
                required: true
            }
        },
        messages: {
            app_module_name: {
                required: 'Please enter the display name'
            },
            app_module_description: {
                required: 'Please enter the description'
            },
            order_sequence: {
                required: 'Please enter the order sequence'
            }
        },
        errorPlacement: function (error, element) {
            showNotification('Attention Required: Error Found', error, 'error', 1500);
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
            const app_module_id = $('#app-module-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update app module';
          
            $.ajax({
                type: 'POST',
                url: 'components/app-module/controller/app-module-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&app_module_id=' + app_module_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get app module details');
                        $('#app-module-modal').modal('hide');
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = page_link;
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

function updateAppLogoForm(){
    $('#app-logo-form').validate({
        rules: {
            app_logo: {
                required: true
            }
        },
        messages: {
            app_logo: {
                required: 'Please choose the app logo'
            }
        },
        errorPlacement: function (error, element) {
            showNotification('Attention Required: Error Found', error, 'error', 1500);
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
            const app_module_id = $('#app-module-id').text();
            const transaction = 'update app logo';
            var formData = new FormData(form);
            formData.append('app_module_id', app_module_id);
            formData.append('transaction', transaction);
        
            $.ajax({
                type: 'POST',
                url: 'components/app-module/controller/app-module-controller.php',
                data: formData,
                processData: false,
                contentType: false,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-app-logo');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get app module details');
                        $('#app-logo-modal').modal('hide');
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
                    handleSystemError(xhr, status, error);
                },
                complete: function() {
                    enableFormSubmitButton('submit-app-logo');
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get app module details':
            var app_module_id = $('#app-module-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            
            $.ajax({
                url: 'components/app-module/controller/app-module-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    app_module_id : app_module_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('app-module-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#app_module_name').val(response.appModuleName);
                        $('#app_module_description').val(response.appModuleDescription);
                        $('#order_sequence').val(response.orderSequence);
                        
                        $('#app_module_name_summary').text(response.appModuleName);
                        $('#app_module_description_summary').text(response.appModuleDescription);
                        $('#order_sequence_summary').text(response.orderSequence);
                    } 
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = page_link;
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
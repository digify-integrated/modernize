(function($) {
    'use strict';

    $(function() {
        checkNotification();
        maxLength();
        initializeFilterDaterange();
        
        $(document).on('click','#copy-error-message',function() {
            copyToClipboard('error-dialog');
        });

        $(document).on('click','.password-addon',function() {
            if (0 < $(this).siblings('input').length) {
                var inputField = $(this).siblings('input');
                var eyeIcon = $(this).find('i');
        
                if (inputField.attr('type') === 'password') {
                    inputField.attr('type', 'text');
                    eyeIcon.removeClass('ti-eye').addClass('ti-eye-off');
                }
                else {
                    inputField.attr('type', 'password');
                    eyeIcon.removeClass('ti-eye-off').addClass('ti-eye');
                }
            }
        });

        $(document).on('click','#datatable-checkbox',function() {
            var status = $(this).is(':checked') ? true : false;
            $('.datatable-checkbox-children').prop('checked',status);
    
            toggleActionDropdown();
        });

        $(document).on('click','.datatable-checkbox-children',function() {
            toggleActionDropdown();
        });
    });
})(jQuery);

function discardCreate(windows_location){
    Swal.fire({
        title: 'Discard Changes Confirmation',
        text: 'You are about to discard your changes. Proceeding will permanently erase any unsaved modifications. Are you sure you want to continue?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Discard',
        cancelButtonText: 'Cancel',
        customClass: {
            confirmButton: 'btn btn-danger mt-2',
            cancelButton: 'btn btn-secondary ms-2 mt-2'
        },
        buttonsStyling: false
    }).then(function(result) {
        if (result.value) {
            window.location = windows_location;
        }
    });
}

function maxLength(){
    if ($('[maxlength]').length) {
        $('[maxlength]').maxlength({
            alwaysShow: true,
            warningClass: 'badge rounded-pill bg-info fs-1 mt-0',
            limitReachedClass: 'badge rounded-pill bg-danger fs-1 mt-0',
        });
    }
}

function checkOptionExist(element, option){
    $(element).val(option).trigger('change');
}

function reloadDatatable(datatable){
    toggleHideActionDropdown();
    $(datatable).DataTable().ajax.reload();
}

function destroyDatatable(datatable_name){
    $(datatable_name).DataTable().clear().destroy();
}

function clearDatatable(datatable_name){
    $(datatable_name).dataTable().fnClearTable();
}

function readjustDatatableColumn() {
    const adjustDataTable = () => {
        const tables = $.fn.dataTable.tables({ visible: true, api: true });
        tables.columns.adjust();
        tables.fixedColumns().relayout();
    };
  
    $('a[data-bs-toggle="tab"], a[data-bs-toggle="pill"], #System-Modal').on('shown.bs.tab shown.bs.modal', adjustDataTable);
}

function toggleActionDropdown(){
    const inputElements = Array.from(document.querySelectorAll('.datatable-checkbox-children'));
    const multipleAction = $('.action-dropdown');
    const checkedValue = inputElements.filter(chk => chk.checked).length;

    multipleAction.toggleClass('d-none', checkedValue === 0);
}

function toggleHideActionDropdown(){
    $('.action-dropdown').addClass('d-none');
    $('#datatable-checkbox').prop('checked', false);
}

function handleColorTheme(e) {
    $('html').attr('data-color-theme', e);
    $(e).prop('checked', !0);
}

function copyToClipboard(elementID) {
    const element = document.getElementById(elementID);
    const text = element.innerHTML;

    navigator.clipboard.writeText(text)
        .then(() => showNotification('Copy Successful', 'Text copied to clipboard', 'success'))
        .catch((err) => showNotification('Copy Error', err, 'danger'));
}

function showErrorDialog(error){
    const errorDialogElement = document.getElementById('error-dialog');

    if (errorDialogElement) {
        errorDialogElement.innerHTML = error;
        $('#system-error-modal').modal('show');
    }
    else {
        console.error('Error dialog element not found.');
    }    
}

function updateFormSubmitButton(buttonId, disabled) {
    try {
        const submitButton = document.querySelector(`#${buttonId}`);
    
        if (submitButton) {
            submitButton.disabled = disabled;
        }
        else {
            console.error(`Button with ID '${buttonId}' not found.`);
        }
    }
    catch (error) {
        console.error(error);
    }
}

function disableFormSubmitButton(buttonId) {
    updateFormSubmitButton(buttonId, true);
}

function enableFormSubmitButton(buttonId) {
    updateFormSubmitButton(buttonId, false);
}

function handleSystemError(xhr, status, error) {
    let fullErrorMessage = `XHR status: ${status}, Error: ${error}${xhr.responseText ? `, Response: ${xhr.responseText}` : ''}`;
    showErrorDialog(fullErrorMessage);
}

function resetModalForm(form_id) {
    var form = document.getElementById(form_id);
  
    form.querySelectorAll('.is-invalid').forEach(function(element) {
        element.classList.remove('is-invalid');
    });
}

function showNotification(notificationTitle, notificationMessage, notificationType, timeOut = 5000) {
    const validNotificationTypes = ['success', 'info', 'warning', 'error'];
    const isDuplicate = isDuplicateNotification(notificationMessage);

    if (!validNotificationTypes.includes(notificationType)) {
        console.error('Invalid notification type:', notificationType);
        return;
    }

    const toastrOptions = {
        closeButton: true,
        progressBar: true,
        newestOnTop: false,
        preventDuplicates: true,
        preventOpenDuplicates: true,
        positionClass: 'toast-top-center',
        timeOut: timeOut,
        showMethod: 'fadeIn',
        hideMethod: 'fadeOut'
    };

    if (!isDuplicate) {
        toastr.options = toastrOptions;
        toastr[notificationType](notificationMessage, notificationTitle);
    }
}

function isDuplicateNotification(message) {
    let isDuplicate = false;
    
    $('.toast').each(function() {
        if ($(this).find('.toast-message').text() === message[0].innerText) {
            isDuplicate = true;
            return false;
        }
    });

    return isDuplicate;
}
  
function setNotification(notificationTitle, notificationMessage, notificationType){
    sessionStorage.setItem('notificationTitle', notificationTitle);
    sessionStorage.setItem('notificationMessage', notificationMessage);
    sessionStorage.setItem('notificationType', notificationType);
}
  
function checkNotification() {
    const { 
        'notificationTitle': notificationTitle, 
        'notificationMessage': notificationMessage, 
        'notificationType': notificationType 
    } = sessionStorage;
    
    if (notificationTitle && notificationMessage && notificationType) {
        sessionStorage.removeItem('notificationTitle');
        sessionStorage.removeItem('notificationMessage');
        sessionStorage.removeItem('notificationType');

        showNotification(notificationTitle, notificationMessage, notificationType);
    }
}

function logNotes(databaseTable, referenceID){
    const type = 'log notes';

    $.ajax({
        type: 'POST',
        url: 'components/global/view/_log_notes_generation.php',
        dataType: 'json',
        data: { type: type, 'database_table': databaseTable, 'reference_id': referenceID },
        success: function (result) {
            document.getElementById('log-notes').innerHTML = result[0].LOG_NOTE;
        }
    });
}

function initializeDualListBoxIcon(){
    $('.moveall i').removeClass().addClass('ti ti-chevron-right');
    $('.removeall i').removeClass().addClass('ti ti-chevron-left');
    $('.move i').removeClass().addClass('ti ti-chevron-right');
    $('.remove i').removeClass().addClass('ti ti-chevron-left');
}

function initializeFilterDaterange(){
    if ($('.filter-daterange').length) {
        $('.filter-daterange').each(function() {
            $(this).daterangepicker({
                ranges: {
                    Today: [moment(), moment()],
                    Yesterday: [
                        moment().subtract(1, 'days'),
                        moment().subtract(1, 'days'),
                    ],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [
                        moment().subtract(1, 'month').startOf('month'),
                        moment().subtract(1, 'month').endOf('month'),
                    ],
                },
                drops: 'up',
                alwaysShowCalendars: true,
                autoUpdateInput: false
            }).on('apply.daterangepicker', function (e, picker) {
                picker.element.val(picker.startDate.format(picker.locale.format) + ' - ' + picker.endDate.format(picker.locale.format));
            }).on('cancel.daterangepicker', function (e, picker) {
                $(this).val('');
                picker.setStartDate({});
                picker.setEndDate({});
            });
        });
        
    }
}
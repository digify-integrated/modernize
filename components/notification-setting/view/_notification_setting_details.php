<div class="row">
    <div class="col-12">
        <div class="card">
            <ul class="nav nav-pills user-profile-tab" id="pills-tab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link position-relative rounded-0 active d-flex align-items-center justify-content-center bg-transparent fs-3 py-4" id="notification-setting-details-tab" data-bs-toggle="pill" data-bs-target="#notification-setting-details" type="button" role="tab" aria-controls="notification-setting-details" aria-selected="true">
                        <i class="ti ti-bell me-2 fs-6"></i>
                        <span class="d-none d-md-block">Notification Setting</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button  class="nav-link position-relative rounded-0 d-flex align-items-center justify-content-center bg-transparent fs-3 py-4" id="notification-channel-tab" data-bs-toggle="pill" data-bs-target="#notification-channel" type="button" role="tab" aria-controls="notification-channel" aria-selected="false">
                        <i class="ti ti-device-tv me-2 fs-6"></i>
                        <span class="d-none d-md-block">Notification Channel</span>
                    </button>
                </li>
            </ul>
            <div class="card-body">
                <div class="tab-content" id="pills-tabContent">
                    <div class="tab-pane fade show active" id="notification-setting-details" role="tabpanel" aria-labelledby="notification-setting-details-tab" tabindex="0">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">Notification Setting</h5>
                                        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                            <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                                            <ul class="dropdown-menu dropdown-menu-end">
                                                <?php
                                                    if($notificationSettingCreateAccess['total'] > 0 || $notificationSettingDeleteAccess['total'] > 0){
                                                        echo $notificationSettingCreateAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Notification Setting</a></li>' : '';

                                                        echo $notificationSettingDeleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-notification-setting">Delete Notification Setting</button></li>' : '';
                                                        
                                                        echo '<li><hr class="dropdown-divider"></li>';
                                                    }
                                                ?>
                                                <li><button class="dropdown-item" type="button" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" id="view-log-notes">View Log Notes</button></li>
                                            </ul>
                                            <?php
                                                echo $notificationSettingWriteAccess['total'] > 0 ? 
                                                '<button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#notification-setting-modal">Edit</button>' : '';
                                            ?>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Display Name:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="notification_setting_name_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Description:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="notification_setting_description_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="notification-channel" role="tabpanel" aria-labelledby="notification-channel-tab" tabindex="0">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">Notification Channel</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="text-bg-light rounded-1 p-6 d-flex align-items-center justify-content-center">
                                                        <i class="ti ti-bell text-dark d-block fs-7" width="22" height="22"></i>
                                                    </div>
                                                    <div>
                                                        <h5 class="fs-4 fw-semibold">System Notification</h5>
                                                    </div>
                                                </div>
                                                <div class="form-check form-switch mb-0">
                                                    <?php
                                                        $checkboxAttributes = ($notificationSettingWriteAccess['total'] > 0) ? '' : 'disabled';

                                                        echo '<input class="form-check-input" type="checkbox" role="switch" id="system-notification" ' . $checkboxAttributes . '>';
                                                    ?>
                                                </div>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="text-bg-light rounded-1 p-6 d-flex align-items-center justify-content-center">
                                                        <i class="ti ti-mail text-dark d-block fs-7" width="22" height="22"></i>
                                                    </div>
                                                    <div>
                                                        <h5 class="fs-4 fw-semibold">Email Notification</h5>
                                                    </div>
                                                </div>
                                                <div class="form-check form-switch mb-0">
                                                    <?php
                                                        $checkboxAttributes = ($notificationSettingWriteAccess['total'] > 0) ? '' : 'disabled';
                                                        
                                                        echo '<input class="form-check-input" type="checkbox" role="switch" id="email-notification" ' . $checkboxAttributes . '>';
                                                    ?>
                                                </div>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="text-bg-light rounded-1 p-6 d-flex align-items-center justify-content-center">
                                                        <i class="ti ti-device-mobile text-dark d-block fs-7" width="22" height="22"></i>
                                                    </div>
                                                    <div>
                                                        <h5 class="fs-4 fw-semibold">SMS Notification</h5>
                                                    </div>
                                                </div>
                                                <div class="form-check form-switch mb-0">
                                                    <?php
                                                        $checkboxAttributes = ($notificationSettingWriteAccess['total'] > 0) ? '' : 'disabled';
                                                        
                                                        echo '<input class="form-check-input" type="checkbox" role="switch" id="sms-notification" ' . $checkboxAttributes . '>';
                                                    ?>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="notification-setting-modal" class="modal fade" tabindex="-1" aria-labelledby="notification-setting-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Notification Setting Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="notification-setting-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="notification_setting_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="notification_setting_name" name="notification_setting_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="notification_setting_description">Description <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="notification_setting_description" name="notification_setting_description" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="notification-setting-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>
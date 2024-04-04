<div class="row">
    <div class="col-12">
        <div class="card">
            <ul class="nav nav-pills user-profile-tab" id="pills-tab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link position-relative rounded-0 active d-flex align-items-center justify-content-center bg-transparent fs-3 py-4" id="account-details-tab" data-bs-toggle="pill" data-bs-target="#account-details" type="button" role="tab" aria-controls="account-details" aria-selected="true">
                        <i class="ti ti-user-circle me-2 fs-6"></i>
                        <span class="d-none d-md-block">Account</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button  class="nav-link position-relative rounded-0 d-flex align-items-center justify-content-center bg-transparent fs-3 py-4" id="security-tab" data-bs-toggle="pill" data-bs-target="#user-role" type="button" role="tab" aria-controls="user-role" aria-selected="false">
                        <i class="ti ti-users me-2 fs-6"></i>
                        <span class="d-none d-md-block">Roles</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button  class="nav-link position-relative rounded-0 d-flex align-items-center justify-content-center bg-transparent fs-3 py-4" id="security-tab" data-bs-toggle="pill" data-bs-target="#security" type="button" role="tab" aria-controls="security" aria-selected="false">
                        <i class="ti ti-lock me-2 fs-6"></i>
                        <span class="d-none d-md-block">Security</span>
                    </button>
                </li>
            </ul>
            <div class="card-body">
                <div class="tab-content" id="pills-tabContent">
                    <div class="tab-pane fade show active" id="account-details" role="tabpanel" aria-labelledby="account-details-tab" tabindex="0">
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">Change Profile</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <div class="text-center">
                                            <img src="./assets/images/profile/user-1.jpg" alt="" class="img-fluid rounded-circle" width="120" height="120">
                                            <div class="d-flex align-items-center justify-content-center my-4 gap-6">
                                                <button class="btn btn-primary">Upload</button>
                                            </div>
                                            <p class="mb-0">Allowed JPG, GIF or PNG. Max size of 800K</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-8">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">User Account</h5>
                                        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                            <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                                            <ul class="dropdown-menu dropdown-menu-end">
                                                <li><a class="dropdown-item" href="user-account.php?new">Create User Account</a></li>
                                                <li><button class="dropdown-item" type="button" id="activate-user-account">Activate User Account</button></li>
                                                <li><button class="dropdown-item" type="button" id="deactivate-user-account">Deactivate User Account</button></li>
                                                <li><button class="dropdown-item" type="button" id="lock-user-account">Lock User Account</button></li>
                                                <li><button class="dropdown-item" type="button" id="unlock-user-account">Unlock User Account</button></li>
                                                <li><button class="dropdown-item" type="button" id="delete-user-account">Delete User Account</button></li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li><button class="dropdown-item" type="button" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" id="view-log-notes">View Log Notes</button></li>
                                            </ul>
                                        </div>
                                        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                            <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#user-account-modal">Edit</button>
                                            <a href="user-account.php?new" class="btn btn-success d-flex align-items-center mb-0">Create</a>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Display Name:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="file_as_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Email:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="email_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">User Account Status:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="active_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Lock Status:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="locked_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Password Expiry Date:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="password_expiry_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Last Connection Date:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="last_connection_date_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Last Password Reset Date:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="last_password_reset_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Account Locked Duration:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="account_lock_duration_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="user-role" role="tabpanel" aria-labelledby="user-role-tab" tabindex="0">
                        <div class="row justify-content-center">
                            <div class="col-lg-8">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">User Roles</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <div class="d-flex align-items-center justify-content-between pb-3">
                                            <div>
                                                <h5 class="fs-4 fw-semibold mb-0">Administrator</h5>
                                                <p class="mb-0 mt-1">Date Assigned: 04/04/2024</p>
                                            </div>
                                            <button class="btn bg-danger-subtle text-danger">Delete</button>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between pb-3">
                                            <div>
                                                <h5 class="fs-4 fw-semibold mb-0">Administrator</h5>
                                                <p class="mb-0 mt-1">Date Assigned: 04/04/2024</p>
                                            </div>
                                            <button class="btn bg-danger-subtle text-danger">Delete</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="security" role="tabpanel" aria-labelledby="security-tab" tabindex="0">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">Security Settings</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="text-bg-light rounded-1 p-6 d-flex align-items-center justify-content-center">
                                                        <i class="ti ti-lock text-dark d-block fs-7" width="22" height="22"></i>
                                                    </div>
                                                    <div>
                                                        <h5 class="fs-4 fw-semibold">Two-factor Authentication</h5>
                                                        <p class="mb-0 text-wrap w-80">Enhance account security with Two-factor Authentication, adding an extra layer of verification beyond passwords to protect sensitive data and mitigate unauthorized access.</p>
                                                    </div>
                                                </div>
                                                <div class="form-check form-switch mb-0">
                                                    <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckChecked">
                                                </div>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="text-bg-light rounded-1 p-6 d-flex align-items-center justify-content-center">
                                                        <i class="ti ti-login text-dark d-block fs-7" width="22" height="22"></i>
                                                    </div>
                                                    <div>
                                                        <h5 class="fs-4 fw-semibold">Multiple Login Sessions</h5>
                                                        <p class="mb-0 text-wrap w-80">Stay informed about account activity with Multiple Login Sessions, receiving notifications for significant changes like new logins from unfamiliar devices or locations, enabling proactive security management.</p>
                                                    </div>
                                                </div>
                                                <div class="form-check form-switch mb-0">
                                                    <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckChecked">
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
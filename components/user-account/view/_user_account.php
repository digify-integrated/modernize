<div  class="datatables">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex align-items-center">
                    <h5 class="card-title mb-0">User Account List</h5>
                    <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                        <button type="button" class="btn btn-dark dropdown-toggle action-dropdown mb-0 d-none" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><button class="dropdown-item" type="button" id="activate-user-account">Activate User Account</button></li>
                            <li><button class="dropdown-item" type="button" id="deactivate-user-account">Deactivate User Account</button></li>
                            <li><button class="dropdown-item" type="button" id="lock-user-account">Lock User Account</button></li>
                            <li><button class="dropdown-item" type="button" id="unlock-user-account">Unlock User Account</button></li>
                            <li><button class="dropdown-item" type="button" id="delete-user-account">Delete User Account</button></li>
                        </ul>
                    </div>
                    <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                        <a href="user-account.php?new" class="btn btn-success d-flex align-items-center mb-0">Create</a>
                        <button type="button" class="btn btn-warning mb-0 px-4" data-bs-toggle="offcanvas" data-bs-target="#filter-offcanvas" aria-controls="filter-offcanvas">Filter</a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="user-account-table" class="table border table-striped table-hover align-middle text-nowrap mb-0">
                            <thead class="text-dark">
                                <tr>
                                    <th class="all">
                                        <div class="form-check">
                                            <input class="form-check-input" id="datatable-checkbox" type="checkbox">
                                        </div>
                                    </th>
                                    <th>User Account</th>
                                    <th>Status</th>
                                    <th>Locked</th>
                                    <th>Password Expiry Date</th>
                                    <th>Last Connection Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="offcanvas offcanvas-start" tabindex="-1" id="filter-offcanvas" aria-labelledby="filter-offcanvas-label">
    <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="filter-offcanvas-label">Filter</h5>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body p-0">
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-2 mx-4 fw-semibold">By User Account Status</h6>
            <div class="pb-2 px-4">
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-status" id="filter-user-account-status-all" value="" checked>
                    <label class="form-check-label" for="filter-user-account-status-all">All</label>
                </div>
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-status" id="filter-user-account-status-yes" value="Yes">
                    <label class="form-check-label" for="filter-user-account-status-yes">Active</label>
                </div>
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-status" id="filter-user-account-status-no" value="No">
                    <label class="form-check-label" for="filter-user-account-status-no">Inactive</label>
                </div>
            </div>
            <h6 class="mb-2 mx-4 fw-semibold">By User Account Lock Status</h6>
            <div class="pb-2 px-4">
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-lock-status" id="filter-user-account-status-lock-all" value="" checked>
                    <label class="form-check-label" for="filter-user-account-status-lock-all">All</label>
                </div>
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-lock-status" id="filter-user-account-status-lock-yes" value="Yes">
                    <label class="form-check-label" for="filter-user-account-status-lock-yes">Yes</label>
                </div>
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-lock-status" id="filter-user-account-status-lock-no" value="No">
                    <label class="form-check-label" for="filter-user-account-status-lock-no">No</label>
                </div>
            </div>
            <h6 class="mb-2 mx-4 fw-semibold">By Password Expiry Date</h6>
            <div class="pb-2 px-4">
                <div class="input-group mb-3">
                    <input type="text" id="filter-password-expiry-date" class="form-control filter-daterange" />
                    <span class="input-group-text">
                        <i class="ti ti-calendar fs-5"></i>
                    </span>
                </div>
            </div>
            <h6 class="mb-2 mx-4 fw-semibold">By Last Connection Date</h6>
            <div class="pb-2 px-4">
                <div class="input-group mb-3">
                    <input type="text" id="filter-last-connection-date" class="form-control filter-daterange" />
                    <span class="input-group-text">
                        <i class="ti ti-calendar fs-5"></i>
                    </span>
                </div>
            </div>
        </div>
        <div class="p-4">
            <button type="button" class="btn btn-warning w-100" id="apply-filter">Apply Filter</button>
        </div>
    </div>
</div>
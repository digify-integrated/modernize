<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Role</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle action-dropdown mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="role.php?new">Create Role</a></li>
                        <li><button class="dropdown-item" type="button" id="delete-role">Delete Role</button></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><button class="dropdown-item" type="button" data-bs-toggle="modal" id="edit-role-permission" data-bs-target="#role-permission-modal">Role Permission</button></li>
                        <li><button class="dropdown-item" type="button" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" id="view-log-notes">View Log Notes</button></li>
                    </ul>
                </div>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#role-modal">Edit</button>
                    <a href="role.php?new" class="btn btn-success d-flex align-items-center mb-0">Create</a>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Display Name:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="role_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Role Description:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="role_description_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="role-modal" class="modal fade" tabindex="-1" aria-labelledby="role-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Role Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="role-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-2">
                                <label class="form-label" for="role_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="role_name" name="role_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-2">
                                <label class="form-label" for="order_sequence">Role Description <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="role_description" name="role_description" maxlength="200"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="role-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="role-permission-modal" class="modal fade" tabindex="-1" aria-labelledby="role-permission-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Role Permission</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div  class="datatables">
                    <div class="row">
                        <div class="col-12">
                            <div class="table-responsive">
                                <table id="role-permission-table" class="table border table-striped table-hover align-middle text-wrap mb-0">
                                    <thead class="text-dark">
                                        <tr>
                                            <th>Menu Item</th>
                                            <th>Read</th>
                                            <th>Create</th>
                                            <th>Write</th>
                                            <th>Delete</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Menu Group</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle action-dropdown mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="menu-group.php?new">Create Menu Group</a></li>
                        <li><button class="dropdown-item" type="button" id="delete-menu-group">Delete Menu Group</button></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><button class="dropdown-item" type="button" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" id="view-log-notes">View Log Notes</button></li>
                    </ul>
                </div>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" data-bs-target="#menu-group-modal">Edit</button>
                    <a href="menu-group.php?new" class="btn btn-success d-flex align-items-center mb-0">Create</a>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Display Name:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="menu_group_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Order Sequence:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="order_sequence_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="menu-group-modal" class="modal fade" tabindex="-1" aria-labelledby="menu-group-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header modal-colored-header bg-info text-white">
                <h4 class="modal-title text-white">Edit Menu Group</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="menu-group-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-4">
                                <label class="col-sm-4 form-label" for="menu_group_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="menu_group_name" name="menu_group_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-4">
                                <label class="col-sm-4 form-label" for="order_sequence">Order Sequence <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="order_sequence" name="order_sequence" min="0">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn bg-danger-subtle text-danger waves-effect" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="menu-group-form" class="btn btn-success mb-0" id="submit-data">Save</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>
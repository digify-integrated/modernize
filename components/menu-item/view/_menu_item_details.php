<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Menu Item</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="menu-item.php?new">Create Menu Item</a></li>
                        <li><button class="dropdown-item" type="button" id="delete-menu-item">Delete Menu Item</button></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><button class="dropdown-item" type="button" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" id="view-log-notes">View Log Notes</button></li>
                    </ul>
                </div>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#menu-item-modal" id="edit-details">Edit</button>
                    <a href="menu-item.php?new" class="btn btn-success d-flex align-items-center mb-0">Create</a>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Display Name:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="menu_item_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Menu Group:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="menu_group_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Order Sequence:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="order_sequence_summary">--</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Parent Menu Item:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="parent_menu_item_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">URL:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="menu_item_url_summary">--</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Menu Icon:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="menu_item_icon_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="datatables">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header d-flex align-items-center">
                    <h5 class="card-title mb-0">Sub Menu Item List</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive ">
                        <table id="submenu-item-table" class="table border table-striped table-hover align-middle text-nowrap mb-0">
                            <thead class="text-dark">
                                <tr>
                                    <th>Submenu Item</th>
                                    <th>Order Sequence</th>
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

<div id="menu-item-modal" class="modal fade" tabindex="-1" aria-labelledby="menu-item-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Menu Item Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="menu-item-form" method="post" action="#">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-2">
                                <label class="form-label" for="menu_item_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="menu_item_name" name="menu_item_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="menu_group">Menu Group <span class="text-danger">*</span></label>
                            <div class="mb-2">
                                <select id="menu_group" name="menu_group" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-2">
                                <label class="form-label" for="order_sequence">Order Sequence <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="order_sequence" name="order_sequence" min="0">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="parent_id">Parent Menu Item</label>
                            <div class="mb-2">
                                <select id="parent_id" name="parent_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-2">
                                <label class="form-label" for="menu_item_url">URL</label>
                                <input type="text" class="form-control maxlength" id="menu_item_url" name="menu_item_url" maxlength="50" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-2">
                                <label class="form-label" for="menu_item_icon">Menu Icon</label>
                                <input type="text" class="form-control maxlength" id="menu_item_icon" name="menu_item_icon" maxlength="50" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="menu-item-form" class="btn btn-success mb-0" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>
<div class="card">
    <div class="card-header d-flex align-items-center">
        <h5 class="card-title mb-0">Menu Group Details</h5>
        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
            <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" data-bs-target="#menu-group-modal">Edit</button>
            <a href="menu-group.php?new" class="btn btn-secondary d-flex align-items-center mb-0">Create</a>
        </div>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-6">
                <div class="form-group row">
                    <label class="form-label text-end col-md-5">Display Name:</label>
                    <div class="col-md-7">
                        <p class="form-control-static" id="menu_group_name_summary">--</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group row">
                    <label class="form-label text-end col-md-5">Order Sequence:</label>
                    <div class="col-md-7">
                        <p class="form-control-static" id="order_sequence_summary">--</p>
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

<div class="card">
    <div class="card-header d-flex align-items-center">
        <h5 class="card-title mb-0">Log Notes</h5>
    </div>
    <div class="card-body">
        <div class="position-relative">
            <div class="p-4 rounded-2 text-bg-light mb-3">
                <div class="d-flex align-items-center gap-3">
                    <img src="./assets/images/profile/user-3.jpg" alt="" class="rounded-circle" width="33" height="33">
                    <h6 class="fw-semibold mb-0 fs-4">Don Russell</h6><br/>
                    <span class="p-1">March 10, 2023 08:30:00 am</span>
                </div>
                <p class="my-3">Es do ujurus nejson imju azgudpi toceztep ji cocicoci bosawrop korze ta. Casetlu udumej umocu wanaro webmos ijafa ud muli amja softoj ma pijum.</p>
            </div>
        </div>
    </div>
</div>
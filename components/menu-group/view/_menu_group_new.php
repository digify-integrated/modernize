<div class="card">
    <div class="card-header d-flex align-items-center">
        <h5 class="card-title mb-0">Menu Group Form</h5>
        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
            <button type="submit" form="menu-group-form" class="btn btn-success" id="submit-data">Save</button>
            <button type="button" id="discard-create" class="btn btn-outline-danger">Discard</button>
        </div>
    </div>
    <div class="card-body">
        <form id="menu-group-form" method="post" action="#">
            <div class="row">
                <div class="col-lg-6">
                    <div class="mb-4 row align-items-center">
                        <label class="col-sm-4 form-label" for="menu_group_name">Display Name <span class="text-danger">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control maxlength" id="menu_group_name" name="menu_group_name" maxlength="100" autocomplete="off">
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="mb-4 row align-items-center">
                        <label class="col-sm-4 form-label" for="order_sequence">Order Sequence <span class="text-danger">*</span></label>
                        <div class="col-sm-8">
                            <input type="number" class="form-control" id="order_sequence" name="order_sequence" min="0">
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
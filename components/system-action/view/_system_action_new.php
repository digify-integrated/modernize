<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">System Action Form</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="submit" form="system-action-form" class="btn btn-success mb-0" id="submit-data">Save</button>
                    <button type="button" id="discard-create" class="btn btn-outline-danger mb-0">Discard</button>
                </div>
            </div>
            <div class="card-body">
                <form id="system-action-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-2">
                                <label class="col-sm-4 form-label" for="system_action_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="system_action_name" name="system_action_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-2">
                                <label class="col-sm-4 form-label" for="order_sequence">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="system_action_description" name="system_action_description" maxlength="200"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<div  class="datatables">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex align-items-center">
                    <h5 class="card-title mb-0">Role List</h5>
                    <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                        <button type="button" class="btn btn-dark dropdown-toggle action-dropdown mb-0 d-none" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><button class="dropdown-item" type="button" id="delete-role">Delete Role</button></li>
                        </ul>
                    </div>
                    <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                        <a href="role.php?new" class="btn btn-success d-flex align-items-center mb-0">Create</a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="role-table" class="table border table-striped table-hover align-middle text-wrap mb-0">
                            <thead class="text-dark">
                                <tr>
                                    <th class="all">
                                        <div class="form-check">
                                            <input class="form-check-input" id="datatable-checkbox" type="checkbox">
                                        </div>
                                    </th>
                                    <th>Role</th>
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
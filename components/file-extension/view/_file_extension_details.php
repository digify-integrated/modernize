<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">File Extension</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <?php
                            if($fileExtensionCreateAccess['total'] > 0 || $fileExtensionDeleteAccess['total'] > 0){
                                echo $fileExtensionCreateAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create File Extension</a></li>' : '';
                                echo $fileExtensionDeleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-file-extension">Delete File Extension</button></li>' : '';
                                
                                echo '<li><hr class="dropdown-divider"></li>';
                            }
                        ?>
                        <li><button class="dropdown-item" type="button" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" id="view-log-notes">View Log Notes</button></li>
                    </ul>
                </div>
                <?php
                    echo $fileExtensionWriteAccess['total'] > 0 ? 
                    '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                        <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#file-extension-modal" id="edit-details">Edit</button>
                    </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Display Name:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="file_extension_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">File Extension:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="file_extension_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">File Type:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="file_type_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="file-extension-modal" class="modal fade" tabindex="-1" aria-labelledby="file-extension-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit File Extension Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="file-extension-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="file_extension_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="file_extension_name" name="file_extension_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="file_extension">File Extension <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="file_extension" name="file_extension" maxlength="10" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <label class="form-label" for="file_type">File Type <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="file_type" name="file_type" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="file-extension-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>
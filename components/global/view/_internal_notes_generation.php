<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../global/model/global-model.php';
require_once '../../user-account/model/user-account-model.php';
require_once '../../global/model/security-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$securityModel = new SecurityModel();
$globalModel = new GlobalModel($databaseModel, $securityModel);
$userAccountModel = new UserAccountModel($databaseModel);

if(isset($_POST['type']) && !empty($_POST['type'])){
    $type = htmlspecialchars($_POST['type'], ENT_QUOTES, 'UTF-8');
    $response = [];
    
    switch ($type) {
        # -------------------------------------------------------------
        #
        # Type: internal notes
        # Description:
        # Generates the internal notes.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'internal notes':
            if(isset($_POST['database_table']) && !empty($_POST['database_table']) && isset($_POST['reference_id']) && !empty($_POST['reference_id'])){
                $internalNote = '';

                $databaseTable = htmlspecialchars($_POST['database_table'], ENT_QUOTES, 'UTF-8');
                $referenceID = htmlspecialchars($_POST['reference_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateInternalNotes(:databaseTable, :referenceID)');
                $sql->bindValue(':databaseTable', $databaseTable, PDO::PARAM_STR);
                $sql->bindValue(':referenceID', $referenceID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $attachment = '';
                    $internalNotesID = $row['internal_notes_id'];
                    $internalNote = $row['internal_note'];
                    $internalNoteBy = $row['internal_note_by'];
                    $timeElapsed = $systemModel->timeElapsedString($row['internal_note_date']);

                    $userDetails = $userAccountModel->getUserAccount($internalNoteBy, null);
                    $fileAs = $userDetails['file_as'];
                    $profilePicture = $systemModel->checkImage($userDetails['profile_picture'] ?? null, 'profile');

                    if(!empty($internalNote)){
                        $internalNote = '<p class="my-3">'. $internalNote .'</p>';
                    }

                    $internalNotesAttachments = $globalModel->getInternalNotesAttachment($internalNotesID);
                    $numberOfValues = count($internalNotesAttachments);

                    if($numberOfValues > 0){
                        foreach ($internalNotesAttachments as $internalNotesAttachment) {
                            $attachmentFileName = $internalNotesAttachment['attachment_file_name'];
                            $attachmentFileSize = $systemModel->getFormatBytes($internalNotesAttachment['attachment_file_size']);
                            $attachmentPathFile = $internalNotesAttachment['attachment_path_file'];
    
                            $attachment .= '<div class="position-relative d-flex gap-2 flex-wrap align-items-center">
                                                <a href="'. $attachmentPathFile .'" class="stretched-link" target="_blank"></a>
                                                <img src="'. $attachmentPathFile .'" width="45" class="rounded" alt="attachment">
                                                <div class="ms-3">
                                                    <h6 class="mb-0 fw-semibold">'. $attachmentFileName .'</h6>
                                                    <span class="fs-2">'. $attachmentFileSize .'</span>
                                                </div>
                                            </div>';
                        }
                    }                    
                    
                    $internalNote .= '<div class="p-4 rounded-4 text-bg-light mb-3">
                                    <div class="d-flex align-items-center gap-6 flex-wrap">
                                        <img src="'. $profilePicture .'" alt="user" class="rounded-circle" width="33" height="33">
                                        <h6 class="mb-0">'. $fileAs .'</h6>
                                        <span class="fs-2">
                                            <span class="p-1 text-bg-muted rounded-circle d-inline-block"></span> '. $timeElapsed .'
                                        </span>
                                    </div>
                                    '. $internalNote .'
                                    '. $attachment .'
                                </div>';
                }

                if(empty($internalNote)){
                    $internalNote = '<div class="p-4 rounded-4 text-bg-light mb-3 text-center">
                                No internal notes found.
                            </div>';
                }

                $response[] = [
                    'INTERNAL_NOTES' => $internalNote
                ];

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------
    }
}

?>
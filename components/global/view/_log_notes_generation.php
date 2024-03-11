<?php
require_once '../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../user/model/user-model.php';
require_once '../../global/model/security-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$userModel = new UserModel($databaseModel);
$securityModel = new SecurityModel();

if(isset($_POST['type']) && !empty($_POST['type'])){
    $type = htmlspecialchars($_POST['type'], ENT_QUOTES, 'UTF-8');
    $response = [];
    
    switch ($type) {
        # -------------------------------------------------------------
        #
        # Type: log notes
        # Description:
        # Generates the log notes.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'log notes':
            if(isset($_POST['database_table']) && !empty($_POST['database_table']) && isset($_POST['reference_id']) && !empty($_POST['reference_id'])){
                $table = '';

                $databaseTable = htmlspecialchars($_POST['database_table'], ENT_QUOTES, 'UTF-8');
                $referenceID = htmlspecialchars($_POST['reference_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateLogNotes(:databaseTable, :referenceID)');
                $sql->bindValue(':databaseTable', $databaseTable, PDO::PARAM_STR);
                $sql->bindValue(':referenceID', $referenceID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $log = $row['log'];
                    $changedBy = $row['changed_by'];
                    $timeElapsed = $systemModel->timeElapsedString($row['changed_at']);
                    
                    $table .= ' <div class="d-flex flex-row comment-row border-bottom p-3 gap-3">
                                    <div>
                                        <span class=""><img src="./assets/images/profile/user-2.jpg" class="rounded-circle" alt="user" width="50" /></span>
                                    </div>
                                    <div class="comment-text w-100">
                                        <h6 class="font-weight-medium">James Anderson</h6>
                                        <div class="comment-footer mb-4">
                                            <span class="text-muted ms-auto fw-normal fs-2 d-block mt-2">'. $timeElapsed .'</span>
                                        </div>
                                        <p class="mb-1 fs-2 text-muted">'. $log .'</p>
                                    </div>
                                </div>';
                }

                $response[] = ['LOG_NOTE' => $table];

                echo json_encode($response);
            }
            else{

            }
        break;
        # -------------------------------------------------------------
    }
}

?>
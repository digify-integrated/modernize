<?php
    $loginCredentialsDetails = $authenticationModel->getLoginCredentials($user_id, null);
    $userFileAs = $loginCredentialsDetails['file_as'];
    $userEmail = $loginCredentialsDetails['email'];
    $multipleSession = $loginCredentialsDetails['multiple_session'];
    $sessionToken = $securityModel->decryptData($loginCredentialsDetails['session_token']);
    
    if ($loginCredentialsDetails['active'] == 'No' || $loginCredentialsDetails['locked'] == 'Yes' || ($_SESSION['session_token'] != $sessionToken && $multipleSession == 'No')) {
        header('location: logout.php?logout');
        exit;
    }
?>
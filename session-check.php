<?php 
session_start();

if (isset($_COOKIE['remember_token']) && !empty($_COOKIE['remember_token'])) {
    $rememberToken = $_COOKIE['remember_token'];

    $user = $userModel->getUserByRememberToken($rememberToken);

    if ($user) {
        $userID = $user['user_id'];

        if(empty($userID)){
            header('Location: index.php');
            exit;
        }

        $_SESSION['user_id'] = $userID;

        $userModel->updateLastConnection($userID, $connectionDate);

        header('Location: dashboard.php');
        exit;
    } 
    else {
        setcookie('remember_token', '', time() - 3600, '/');
        unset($_COOKIE['remember_token']);
    }
}

if (isset($_SESSION['user_id']) && !empty($_SESSION['user_id'])) {
    header('Location: dashboard.php');
    exit;
}

?>
<?php   
session_start();

if (isset($_SESSION['user_account_id']) && !empty($_SESSION['user_account_id'])) {
    $user_id = $_SESSION['user_account_id'];
} 
else {
    session_unset();
    session_destroy();
    header('location: index.php');
    exit();
}
?>
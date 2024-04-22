<?php
    if (!isset($_GET['page_id']) || empty($_GET['page_id'])) {
        header('location: dashboard.php');
        exit;
    }

    $pageID = $securityModel->decryptData($_GET['page_id']);
    
    $pageDetails = $menuItemModel->getMenuItem($pageID);
    $pageTitle = $pageDetails['menu_item_name'] ?? null;
    $pageURL = $pageDetails['menu_item_url'] ?? null;
    $pageGroup = $pageDetails['menu_group_name'] ?? null;
    $pageLink = $pageURL . '?page_id=' . $securityModel->encryptData($pageID);

    if(isset($_GET['id'])){
        if(empty($_GET['id'])){
            header('location: ' . $pageURL);
            exit;
        }
    
        $detailID = $securityModel->decryptData($_GET['id']);
    }
    else{
        $detailID = null;
    }
    
    $newRecord = isset($_GET['new']);
?>
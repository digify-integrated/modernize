<?php    
    $pageTitle = '404';
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
    <?php include_once('view/_head.php'); ?>
</head>

<body>
    <?php include_once('view/_preloader.php'); ?>
    <div id="main-wrapper">
    <div class="position-relative overflow-hidden min-vh-100 w-100 d-flex align-items-center justify-content-center">
      <div class="d-flex align-items-center justify-content-center w-100">
        <div class="row justify-content-center w-100">
          <div class="col-lg-4">
            <div class="text-center">
              <img src="./assets/images/backgrounds/errorimg.svg" alt="" class="img-fluid" width="500">
              <h1 class="fw-semibold mb-7 fs-9">Oops!!!</h1>
              <h4 class="fw-semibold mb-7">This page you are looking for could not be found.</h4>
              <a class="btn btn-primary" href="index.php" role="button">Go back to home</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
    <div class="dark-transparent sidebartoggler"></div>
    <?php 
        include_once('view/_global_js.php');
    ?>
</body>
</html>
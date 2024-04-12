<aside class="left-sidebar with-vertical">
    <div>
        <div class="brand-logo d-flex align-items-center justify-content-between">
            <a href="dashboard.php" class="text-nowrap logo-img">
                <img src="./assets/images/logos/dark-logo.svg" class="dark-logo" alt="Logo-Dark"/>
                <img src="./assets/images/logos/light-logo.svg" class="light-logo"  alt="Logo-light"/>
            </a>
            <a href="javascript:void(0)" class="sidebartoggler ms-auto text-decoration-none fs-5 d-block d-xl-none">
                <i class="ti ti-x"></i>
            </a>
        </div>
        <nav class="sidebar-nav scroll-sidebar" data-simplebar>
            <ul id="sidebarnav">
                <li class="nav-small-cap">
                    <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
                    <span class="hide-menu">Home</span>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="dashboard.php" aria-expanded="false">
                        <span><i class="ti ti-home"></i></span>
                        <span class="hide-menu">Dashboard</span>
                    </a>
                </li>
                <?php
                    $menu = '';
                
                    $sql = $databaseModel->getConnection()->prepare('CALL buildMenuGroup(:userID)');
                    $sql->bindValue(':userID', $userID, PDO::PARAM_INT);
                    $sql->execute();
                    $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                    $sql->closeCursor();
            
                    foreach ($options as $row) {
                        $menuGroupID = $row['menu_group_id'];
                        $menuGroupName = $row['menu_group_name'];
        
                        $menu .= '<li class="nav-small-cap">
                                        <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
                                        <span class="hide-menu">'. $menuGroupName .'</span>
                                    </li>';
        
                        $menu .= $globalModel->buildMenuItem($userID, $menuGroupID);
                    }
            
                    echo $menu;
                ?>
            </ul>
        </nav>
    </div>
</aside>
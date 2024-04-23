<?php
/**
* Class GlobalModel
*
* The GlobalModel class handles global related operations and interactions.
*/
class GlobalModel {
    public $db;
    public $securityModel;

    public function __construct(DatabaseModel $db, SecurityModel $securityModel) {
        $this->db = $db;
        $this->securityModel = $securityModel;
    }

    # -------------------------------------------------------------
    #   Check methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkAccessRights
    # Description: Checks if the user has access.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_menu_item_id (int): The menu item ID.
    # - $p_access_type (string): The access type.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkAccessRights($p_user_account_id, $p_menu_item_id, $p_access_type) {
        $stmt = $this->db->getConnection()->prepare('CALL checkAccessRights(:p_user_account_id, :p_menu_item_id, :p_access_type)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_menu_item_id', $p_menu_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_access_type', $p_access_type, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkSystemActionAccessRights
    # Description: Checks if the user has access.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_system_action_id (int): The system action ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkSystemActionAccessRights($p_user_account_id, $p_system_action_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkSystemActionAccessRights(:p_user_account_id, :p_system_action_id)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_system_action_id', $p_system_action_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Build methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: buildMenuItem
    # Description: Generates the menu item options.
    #
    # Parameters:
    # - $p_user_account_id (int): The user ID.
    # - $p_menu_group_id (int): The menu group ID.
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function buildMenuItem($p_user_account_id, $p_menu_group_id) {
        $menuItems = [];

        $stmt = $this->db->getConnection()->prepare('CALL buildMenuItem(:p_user_account_id, :p_menu_group_id)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_menu_group_id', $p_menu_group_id, PDO::PARAM_INT);
        $stmt->execute();
        $count = $stmt->rowCount();

        if($count > 0){
            $options = $stmt->fetchAll(PDO::FETCH_ASSOC);
            $stmt->closeCursor();

            foreach ($options as $row) {
                $menuItemID = $row['menu_item_id'];
                $menuItemName = $row['menu_item_name'];
                $menuItemURL = $row['menu_item_url'] ?? null;
                $parentID = $row['parent_id'];
                $menuItemIcon = !empty($row['menu_item_icon']) ? $row['menu_item_icon'] : null;

                $menuItem = [
                    'MENU_ITEM_ID' => $menuItemID,
                    'MENU_ITEM_NAME' => $menuItemName,
                    'MENU_ITEM_URL' => $menuItemURL,
                    'PARENT_ID' => $parentID,
                    'MENU_ITEM_ICON' => $menuItemIcon,
                    'CHILDREN' => []
                ];

                $menuItems[$menuItemID] = $menuItem;
            }

            foreach ($menuItems as $menuItem) {
                if (!empty($menuItem['PARENT_ID'])) {
                    $menuItems[$menuItem['PARENT_ID']]['CHILDREN'][] = &$menuItems[$menuItem['MENU_ITEM_ID']];
                }
            }

            $rootMenuItems = array_filter($menuItems, function ($item) {
                return empty($item['PARENT_ID']);
            });

            $html = '';

            foreach ($rootMenuItems as $rootMenuItem) {
                $html .= $this->buildMenuItemHTML($rootMenuItem);
            }

            return $html;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: buildMenuItemHTML
    # Description: Generates the menu item html.
    #
    # Parameters:
    # - $menuItemDetails (array): The menu item details.
    # - $level (int): The menu item level.
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function buildMenuItemHTML($menuItemDetails, $level = 1) {
        $html = '';
        $menuItemID = $this->securityModel->encryptData($menuItemDetails['MENU_ITEM_ID']);
        $menuItemName = $menuItemDetails['MENU_ITEM_NAME'];
        $menuItemIcon = $menuItemDetails['MENU_ITEM_ICON'];
        $menuItemURL = $menuItemDetails['MENU_ITEM_URL'];
        $children = $menuItemDetails['CHILDREN'];
    
        $menuItemURL = !empty($menuItemURL) ? (strpos($menuItemURL, '?page_id=') !== false ? $menuItemURL : $menuItemURL . '?page_id=' . $menuItemID) : 'javascript:void(0)';
    
        if ($level === 1) {
            if (empty($children)) {
                $html .= '<li class="sidebar-item">
                                <a class="sidebar-link" href="'. $menuItemURL .'" aria-expanded="false">
                                <span>
                                    <i class="'. $menuItemIcon .'"></i>
                                </span>
                                <span class="hide-menu">'. $menuItemName .'</span>
                                </a>
                            </li>';
            } else {
                $html .= ' <li class="sidebar-item">
                                <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                                    <span class="d-flex">
                                        <i class="'. $menuItemIcon .'"></i>
                                    </span>
                                    <span class="hide-menu">'. $menuItemName .'</span>
                                </a>
                                <ul aria-expanded="false" class="collapse first-level">';
    
                foreach ($children as $child) {
                    $html .= $this->buildMenuItemHTML($child, $level + 1);
                }
    
                $html .= '</ul>
                        </li>';
            }
        } else {
            if (empty($children)) {
                $html .= '<li class="sidebar-item">
                                <a href="'. $menuItemURL .'" class="sidebar-link">
                                <div class="round-16 d-flex align-items-center justify-content-center">
                                    <i class="ti ti-circle"></i>
                                </div>
                                <span class="hide-menu">'. $menuItemName .'</span>
                                </a>
                            </li>';
            } else {
                $html .= '<li class="sidebar-item">
                                <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                                    <div class="round-16 d-flex align-items-center justify-content-center">
                                        <i class="ti ti-circle"></i>
                                    </div>
                                    <span class="hide-menu">'. $menuItemName .'</span>
                                </a>
                                <ul aria-expanded="false" class="collapse two-level">';
    
                foreach ($children as $child) {
                    $html .= $this->buildMenuItemHTML($child, $level + 1);
                }
    
                $html .= '</ul>
                        </li>';
            }
        }
    
        return $html;
    }    
    # -------------------------------------------------------------
}
?>
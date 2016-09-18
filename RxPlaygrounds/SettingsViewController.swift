//
//  SettingsViewController.swift
//  RxPlaygrounds
//
//  Created by 杨弘宇 on 2016/9/18.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let sizeThatFits = self.tableView.sizeThatFits(CGSize(width: self.view.bounds.width, height: CGFloat(MAXFLOAT)))
        UIView.animate(withDuration: 0.5) { 
            self.preferredContentSize = sizeThatFits
        }
    }

}

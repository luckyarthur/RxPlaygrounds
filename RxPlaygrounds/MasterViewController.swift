//
//  MasterViewController.swift
//  RxPlaygrounds
//
//  Created by 杨弘宇 on 2016/9/17.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    let example = ExampleOperators()


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOperatorDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedOperator = self.example.operators[indexPath.row]
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.title = "\(selectedOperator.0.firstLetterUppercased) operator"
                controller.currentOperator = selectedOperator.1
            }
        }
        
        if segue.identifier == "showSettings" {
            let settingsVC = (segue.destination as! UINavigationController).topViewController as! SettingsViewController
            return
        }
        
        let commonController = (segue.destination as! UINavigationController).topViewController
        commonController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        commonController?.navigationItem.leftItemsSupplementBackButton = true
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.example.operators.count
        case 1:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        switch (indexPath.section, indexPath.row) {
        case (0, _):
            cell.textLabel!.text = self.example.operators[indexPath.row].0
            break
        case (1, 0):
            cell.textLabel!.text = "About"
            break
        default:
            break
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            self.performSegue(withIdentifier: "showOperatorDetail", sender: self)
            break
        case (1, 0):
            self.performSegue(withIdentifier: "showAboutDetail", sender: self)
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Operators"
        default:
            return nil
        }
    }
    
}


//
//  DreamsTableViewController.swift
//  Bauman, Brian Dreamcatcher
//
//  Created by Brian Bauman on 3/14/19.
//  Copyright © 2019 Brian Bauman. All rights reserved.
//

import UIKit

class DreamsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let dream = dreams[indexPath.row]
        let alertController = UIAlertController(title: dream.title,
                                                message: dream.description,
                                                preferredStyle: .actionSheet)
        let okayAction = UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil)
        alertController.addAction(okayAction)
        present(alertController,
                animated: true,
                completion: nil)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDreams.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dream = filteredDreams[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: dream.category, for: indexPath)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        cell.textLabel?.text = "(\(dateFormatter.string(from: dream.date))) \(dream.title)"
        cell.detailTextLabel?.text = dream.tag

        return cell
    }
}

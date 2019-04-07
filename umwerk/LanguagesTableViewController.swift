//
//  LanguagesTableViewController.swift
//  umwerkBlack
//
//  Created by Kenan Mamedoff on 04/04/2019.
//  Copyright © 2019 Kenan Mamedoff. All rights reserved.
//
import UIKit

class LanguagesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programmingLanguages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentProgrammingLanguage = programmingLanguages[indexPath.row]
        
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Load Language Notification"), object: nil)
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Languages Cell", for: indexPath) as! LanguagesTableViewCell
        
        cell.languageNameLabel.text = programmingLanguages[indexPath.row]
        
        return cell
    }
    
}


//
//  ListViewController.swift
//  umwerkBlack
//
//  Created by Kenan Mamedoff on 04/04/2019.
//  Copyright © 2019 Kenan Mamedoff. All rights reserved.
//

import UIKit
import Kingfisher

struct Developer: Decodable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [DeveloperItems]?
}

struct DeveloperItems: Decodable {
    let login: String?
    let url: String?
    let avatarUrl: String?
    var createdAt: String?
}

struct DeveloperInfo: Decodable {
    let login: String?
    let url: String?
    let name: String?
    let blog: String
    let company: String?
    let location: String?
    let email: String?
    let bio: String?
    let avatarUrl: String?
    let followers: Int?
    let following: Int?
    let createdAt: String?
}

class ListViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var newBackgroundColor: UIColor!
    var homeFeedDevelopersData = [DeveloperInfo]()
    var isLoading = false
    var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadLanguage), name: NSNotification.Name(rawValue: "Load Language Notification"), object: nil)
        
        let rightBarButtonItem = UIBarButtonItem(title: "LANGS▼", style: .done, target: self, action: #selector(languageList))
        self.navigationItem.rightBarButtonItem  = rightBarButtonItem
        
        fetchUsers(countPerPage: 10, languageName: currentProgrammingLanguage, pageNumber: pageNumber)
        title = currentProgrammingLanguage.lowercased()
    }
    
    @objc func languageList(){
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "Languages VC") else { return }
        popVC.modalPresentationStyle = .popover
        
        let barButtonItem = self.navigationItem.rightBarButtonItem!
        let buttonItemView = barButtonItem.value(forKey: "view") as? UIView
        
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = buttonItemView
        popOverVC?.sourceRect = buttonItemView!.bounds
        
        self.present(popVC, animated: true)
    }
    
    @objc func loadLanguage(){
        homeFeedDevelopersData = [DeveloperInfo]()
        isLoading = false
        pageNumber = 1

        fetchUsers(countPerPage: 10, languageName: currentProgrammingLanguage.lowercased(), pageNumber: pageNumber)
        title = currentProgrammingLanguage.lowercased()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate             = UIApplication.shared.delegate as! AppDelegate
        self.newBackgroundColor                = appDelegate.viewColor
        self.view.backgroundColor   = self.newBackgroundColor
    }
    
    func fetchUsers(countPerPage: Int, languageName: String, pageNumber: Int) {
        let requestUrl = "\(apiURL)/search/users?q=language:\(languageName.lowercased())&sort=stars&order=desc&page=\(pageNumber)&per_page=\(countPerPage)"
        Service.shared.fetchGenericData(urlString: requestUrl) { (feed: Developer) in
            guard let items = feed.items else {
                return
            }
            
            guard let login = items.randomElement()!.login else { return }
            UserDefaults(suiteName: "group.ublackt")!.set(login, forKey: "developerName")
            
            for item in items {
                let authLink = String(format: "\(item.url!)")
                
                Service.shared.fetchGenericData(urlString: authLink) { (feed: DeveloperInfo) in
                    self.homeFeedDevelopersData.append(feed)

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        
        let bgView = UIView()
        bgView.backgroundColor = self.newBackgroundColor
        cell.backgroundColor = self.newBackgroundColor
        cell.backgroundView = bgView
        cell.layer.cornerRadius = 3.0
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = true
        
        if let avatar = homeFeedDevelopersData[indexPath.row].avatarUrl {
            cell.avatarImageView.kf.setImage(with: URL(string: avatar))
        }
        
        if let username = homeFeedDevelopersData[indexPath.row].login {
            cell.nameLabel.text = username
        }
        
        if let creationDate = homeFeedDevelopersData[indexPath.row].createdAt {
            cell.userTypeLabel.text = creationDate
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !isLoading && indexPath.row == homeFeedDevelopersData.count - 3 {
            isLoading = true
            pageNumber += 1
            
            fetchUsers(countPerPage: 10, languageName: currentProgrammingLanguage, pageNumber: pageNumber)
            
            isLoading = false
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeFeedDevelopersData.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetails", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            let nextScene = segue.destination as? DetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            nextScene?.homeFeedDevelopersData = homeFeedDevelopersData[indexPath?.row ?? 0]
        }
    }
    
}

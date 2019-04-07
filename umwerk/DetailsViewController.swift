//
//  DetailsViewController.swift
//  umwerkBlack
//
//  Created by Kenan Mamedoff on 04/04/2019.
//  Copyright © 2019 Kenan Mamedoff. All rights reserved.
//

import Kingfisher
import MessageUI

class DetailsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var emailButtonOutlet: UIButton!
    @IBOutlet weak var websiteButtonOutlet: UIButton!
    @IBOutlet weak var followersValue: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    var homeFeedDevelopersData: DeveloperInfo?
    var cellTitles: [String] = ["Login", "Name", "URL", "Blog", "Company", "Location", "Email", "Hireable", "Bio", "Followers", "Following", "Created"]
    var selectedDeveloper: Developer!
    var bgColor: UIColor!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgColor = appDelegate.viewColor
        view.backgroundColor   = self.bgColor
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        emailButtonOutlet.isEnabled = false
        websiteButtonOutlet.isEnabled = false
        
        if let login = homeFeedDevelopersData?.login {
            infoTextView.text += "Login: " + String(login) + "\n"
        }
        if let name = homeFeedDevelopersData?.name {
            infoTextView.text += "Name: " + String(name) + "\n"
        }
        if let company = homeFeedDevelopersData?.company {
            infoTextView.text += "Company: " + String(company) + "\n"
        }
        if let location = homeFeedDevelopersData?.location {
            infoTextView.text += "Location: " + String(location) + "\n"
        }
        if let bio = homeFeedDevelopersData?.bio {
            infoTextView.text += "Bio: " + String(bio) + "\n"
        }
        if let followers = homeFeedDevelopersData?.followers {
            infoTextView.text += "Followers: " + String(followers) + "\n"
            followersValue.text = "Followers: " + String(followers)
        }
        if let following = homeFeedDevelopersData?.following {
            infoTextView.text += "Following: " + String(following) + "\n"
        }
        if let createdAt = homeFeedDevelopersData?.createdAt {
            infoTextView.text += "Created: " + String(createdAt) + "\n"
        }
        if let email = homeFeedDevelopersData?.email {
            if validateEmail(enteredEmail: email) {
                emailButtonOutlet.isEnabled = true
            }
        }
        if let _ = homeFeedDevelopersData?.blog {
            websiteButtonOutlet.isEnabled = true
        }
        if let avatar = homeFeedDevelopersData?.avatarUrl {
            profileImage.kf.setImage(with: URL(string: avatar))
        }
    }
    
    @IBAction func emailButtonAction(_ sender: UIButton) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        guard let email = homeFeedDevelopersData?.email else { return }
        composeVC.setToRecipients([email])
        composeVC.setSubject("Hello.")
        composeVC.setMessageBody("", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func websiteButtonAction(_ sender: UIButton) {
        guard let blog = homeFeedDevelopersData?.blog else { return }
        
        guard let url = URL(string: blog) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

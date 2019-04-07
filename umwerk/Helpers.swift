//
//  API.swift
//  umwerkBlack
//
//  Created by Kenan Mamedoff on 04/04/2019.
//  Copyright © 2019 Kenan Mamedoff. All rights reserved.
//

import UIKit

let programmingLanguages = ["Java", "Python", "CSS", "PHP", "Ruby", "C", "Shell", "R", "VimL", "Go", "Perl", "CoffeeScript", "TeX", "Swift", "Scala", "Haskell", "Lua", "Clojure", "Matlab", "Arduino", "Rust", "PowerShell"]
var currentProgrammingLanguage: String = "Java"
let apiURL = "https://api.github.com"
let personalAccessToken = "8b0efaf1ba9b54af48e1a7c43e8d7aef29178231"

struct Service {
    static let shared = Service()
    
    func fetchGenericData<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = "GET"
        req.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        req.addValue("token \(personalAccessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 403 {
                print("error code \(httpResponse.statusCode)")
                
                return
            } else if httpResponse.statusCode == 200 {
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let homeFeed = try decoder.decode(T.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(homeFeed)
                    }
                } catch let jsonErr {
                    print("Failed to serialize JSON:", jsonErr)
                }
            }
        }
        task.resume()
    }
}

func validateEmail(enteredEmail:String) -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    
    return emailPredicate.evaluate(with: enteredEmail)
}

extension UIViewController {
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

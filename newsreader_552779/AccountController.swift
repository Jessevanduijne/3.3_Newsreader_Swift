//
//  AccountController.swift
//  newsreader_552779
//
//  Created by Informatica Haarlem on 23-10-19.
//  Copyright © 2019 Informatica Haarlem. All rights reserved.
//

import Foundation
import UIKit

class AccountController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var feedbackMessage: UILabel!
    @IBOutlet weak var switchLoginRegisterButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    let defaults = UserDefaults.standard
    private var loginModus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        self.usernameLabel.text = NSLocalizedString("lbl_username", comment: "")
        self.passwordLabel.text = NSLocalizedString("lbl_password", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func confirmButtonClick(_ sender: Any) {
        let username = usernameField.text
        let password = passwordField.text
        let decoder = JSONDecoder()
        
        if(username == "" || password == "") {
            feedbackMessage.text = NSLocalizedString("lbl_msg_enter_credentials", comment: "")
            return
        }
        
        if(loginModus) {
            let loginRequest = ArticlesAPI.login(username: username!, password: password!)
            
            loginRequest.responseData(completionHandler: {[weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decodedLoginJson = try? decoder.decode(Login.self, from: jsonData)
                if(decodedLoginJson != nil) {
                    let authToken = decodedLoginJson!.AuthToken
                    let defaults = UserDefaults.standard
                    defaults.set(authToken, forKey: "authToken")
                    defaults.set(username, forKey: "username")
                    
                    // Go back to page                   
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let articlesVC = storyboard.instantiateViewController(withIdentifier: "ArticlesViewController")
                    self?.navigationController?.pushViewController(articlesVC, animated: true)
                }
                else {
                    self?.feedbackMessage.text = NSLocalizedString("lbl_msg_wrong_credentials", comment: "")
                    return
                }
            })
        }
        else {
            let registerRequest = ArticlesAPI.register(username: username!, password: password!)
            registerRequest.responseData(completionHandler: {[weak self] (response) in
                guard let jsonData = response.data else { return }
                let decodedRegisterJson = try? decoder.decode(Register.self, from: jsonData)
                let success = decodedRegisterJson!.Success
                if(success == false) {
                    self?.feedbackMessage.text = NSLocalizedString("lbl_msg_username_already_exists", comment: "")
                }
                else {
                    self?.switchModus() // Switch to login label info
                    self?.feedbackMessage.text = NSLocalizedString("lbl_msg_account_created", comment: "")
                }
            })
        }
    }
    
    @IBAction func switchLoginRegisterClick(_ sender: Any) {
        switchModus()
    }

    private func switchModus() {
        if(loginModus) {
            confirmButton.setTitle(NSLocalizedString("btn_register", comment: ""), for: .normal)
            switchLoginRegisterButton.setTitle(NSLocalizedString("btn_navigate_login_page", comment: ""), for: .normal)
            loginModus = false
        }
        else {
            confirmButton.setTitle(NSLocalizedString("btn_login", comment: ""), for: .normal)
            switchLoginRegisterButton.setTitle(NSLocalizedString("btn_navigate_register_page", comment: ""), for: .normal)
            loginModus = true
        }
    }
}

//
//  SecondViewController.swift
//  newsreader_552779
//
//  Created by Informatica Haarlem on 16-10-19.
//  Copyright © 2019 Informatica Haarlem. All rights reserved.
//

import UIKit
import Foundation

class LikedViewController: UIViewController {

    @IBOutlet weak var likedArticlesTableView: UITableView!
    @IBOutlet weak var navBarLoginButton: UIBarButtonItem!
    
    var likedArticles = [Article]()
    let defaults = UserDefaults.standard
    var pendingNetworkRequest = false
    let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var loggedin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
        attachDataToView()
        setupRefreshControl()
        setupSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavbarLoginStatus()
        
        // If user logs out in the articles (not liked-) list, it has to empty
        likedArticles.removeAll()
        likedArticlesTableView.reloadData()
        addArticles()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func addArticles() {
        let authToken = defaults.string(forKey: "authToken")
        if(authToken != nil && authToken != "") {
            loggedin = true
            activityIndicator.startAnimating()
            let request = ArticlesAPI.likedArticles()
            let decoder = JSONDecoder()
            
            request.responseData(completionHandler: {[weak self] (response) in
                guard let jsonData = response.data else { return }
                let decodedJson = try? decoder.decode(Articles.self, from: jsonData)
                self?.likedArticles.append(contentsOf: decodedJson!.Results)
                self?.likedArticlesTableView.reloadData()
                self?.activityIndicator.stopAnimating()
            })
        }
        else {
            // TODO: Show empty list cell with message
            
        }
    }
    
    private func attachDataToView(){
        self.likedArticlesTableView.dataSource = self
        self.likedArticlesTableView.register(
            UINib(nibName: "ArticleListCell", bundle: nil),
            forCellReuseIdentifier: "ArticleListCell")
    }
    
    private func setNavbarLoginStatus() {
        let username = defaults.string(forKey: "username")
        if (username != nil) {
            navBarLoginButton?.title = String(format: NSLocalizedString("btn_logout", comment: ""), username!)
        }
        else {
            navBarLoginButton?.title = NSLocalizedString("btn_login_or_register", comment: "")
        }
    }
    
    private func setupRefreshControl() {
        likedArticlesTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupSpinner() {
        self.activityIndicator.center = (self.view.center)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.activityIndicator.color = UIColor.blue
        self.activityIndicator.transform = CGAffineTransform(scaleX: 5, y: 5)
        view.addSubview((self.activityIndicator))
    }
    
    @objc func refresh(){
        setNavbarLoginStatus()
        likedArticlesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @IBAction func logoutButtonClick(_ sender: Any) {
        let authToken = defaults.string(forKey: "authToken")
        
        // login
        if(authToken == nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let accountVC = storyboard.instantiateViewController(withIdentifier: "AccountController")
            self.navigationController?.pushViewController(accountVC, animated: true)
        }
            
        // logout, stay on page:
        else {
            // clear credentials
            defaults.set(nil, forKey: "authToken")
            defaults.set(nil, forKey: "username")
            
            self.navBarLoginButton.title = NSLocalizedString("btn_login_or_register", comment: "")
            
            self.likedArticles.removeAll()
            self.likedArticlesTableView.reloadData()
        }
        refresh()
    }
    
    

}

extension LikedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(loggedin) {
            if (likedArticles.count == 0) {
                tableView.setEmptyMessage(NSLocalizedString("lbl_no_liked_articles", comment: ""))
            } else {
                tableView.restore()
            }
        }
        else {
            tableView.setEmptyMessage(NSLocalizedString("lbl_not_logged_in", comment: ""))
        }
        
     
        
        return likedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listitem = likedArticlesTableView.dequeueReusableCell(withIdentifier: "ArticleListCell", for: indexPath) as! ArticleListCell
        
        let url = URL(string: likedArticles[indexPath.row].Image)
        
        listitem.articleListTitle.text = likedArticles[indexPath.row].Title
        listitem.articleListImage.kf.setImage(with: url)
        listitem.articleID = likedArticles[indexPath.row].Id
        listitem.likeButton.isHidden = true
        
        return listitem
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}



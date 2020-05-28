//
//  FirstViewController.swift
//  newsreader_552779
//
//  Created by Informatica Haarlem on 16-10-19.
//  Copyright © 2019 Informatica Haarlem. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class ArticlesViewController: UIViewController {

    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet weak var navBarLoginButton: UIBarButtonItem!
    
    var articles = [Article]()
    var pendingNetworkRequest = false
    let defaults = UserDefaults.standard
    let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var nextId: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
        addArticles() // initial 20 articles
        setNavbarLoginStatus()
        attachDataToView()
        setupRefreshControl()
        setupSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavbarLoginStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func addArticles() {
        self.activityIndicator.startAnimating()
        let request = ArticlesAPI.getArticles(nextID: nextId)
        let decoder = JSONDecoder()
        
        request.responseData(completionHandler: {[weak self] (response) in
            
            guard let jsonData = response.data else { return }
            let decodedJson = try? decoder.decode(Articles.self, from: jsonData)
            self?.nextId = decodedJson!.NextID
            self?.articles.append(contentsOf: decodedJson!.Results)
            self?.articlesTableView.reloadData()
            self?.activityIndicator.stopAnimating()
        })
    }
    
    private func attachDataToView(){
        self.articlesTableView.dataSource = self
        self.articlesTableView.register(
            UINib(nibName: "ArticleListCell", bundle: nil),
            forCellReuseIdentifier: "ArticleListCell")
        articlesTableView.delegate = self
    }
    
    private func setNavbarLoginStatus() {
        self.navigationItem.setHidesBackButton(true, animated:true)
        let username = defaults.string(forKey: "username")
        if (username != nil) {
            navBarLoginButton?.title = String(format: NSLocalizedString("btn_logout", comment: ""), username!)
        }
        else {
            navBarLoginButton?.title = NSLocalizedString("btn_login_or_register", comment: "")
        }
    }
    
    private func setupRefreshControl() {
        articlesTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupSpinner() {
        self.activityIndicator.center = (self.view.center)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.activityIndicator.color = Color.blue
        self.activityIndicator.transform = CGAffineTransform(scaleX: 5, y: 5)
        view.addSubview((self.activityIndicator))
    }
    
    @objc func refresh(){
        addArticles()
        setNavbarLoginStatus()
        articlesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @IBAction func logoutClick(_ sender: Any) {
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
            
            
            self.articlesTableView.reloadData()
        }
        refresh()
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listitem = articlesTableView.dequeueReusableCell(withIdentifier: "ArticleListCell", for: indexPath) as! ArticleListCell
        
        let url = URL(string: articles[indexPath.row].Image)
        let placeholder = UIImage(named: "placeholder")
        
        listitem.articleListTitle.text = articles[indexPath.row].Title
        listitem.articleListImage.kf.setImage(with: url, placeholder: placeholder)
        listitem.articleID = articles[indexPath.row].Id
        
        // dont show like option when not logged in:
        let authToken = defaults.string(forKey: "authToken")
        if(authToken == nil) {
            listitem.likeButton.isHidden = true
        }
        
        // show already liked items on initial load:
        if(articles[indexPath.row].IsLiked == true) {
            listitem.likeButton.setImage(UIImage(named: "likedstar"), for: .normal)
        }
        else {
            listitem.likeButton.setImage(UIImage(named: "notlikedstar"), for: .normal)
        }
        
        return listitem
    }
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let articleDetailController = storyboard.instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController
        
        articleDetailController.article = articles[indexPath.row]
        self.navigationController?.pushViewController(articleDetailController, animated: true)        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalArticles = articles.count
        
        guard indexPath.row >= totalArticles - 1 else { return }
        guard pendingNetworkRequest == false else { return }
        
        addArticles()
    }
}

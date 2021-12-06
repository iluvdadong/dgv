//
//  ViewController.swift
//  DGV
//
//  Created by DaHae Kim on 2021/12/02.
//

import UIKit
import Alamofire

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.text = "라라랜드"
        searchMovies()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Naver Movie Search API
    func searchMovies() {
        
        let url = API.BASE_URL + "v1/search/movie.json"
        
        guard let searchKeyword = self.searchBar.text else { return }
        
//        let queryParam = ["query": searchKeyword]
        let queryParam = ["query": "듄"]

        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "X-Naver-Client-Id": API.CLIENT_ID,
            "X-Naver-Client-Secret": API.CLIENT_SECRET
        ]
        
        AF.request(url, method: .get, parameters: queryParam, headers: headers).response { response in
            debugPrint(response)
        }
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
        return  cell
    }
    
}

extension MovieListViewController: UITableViewDelegate {
    
}

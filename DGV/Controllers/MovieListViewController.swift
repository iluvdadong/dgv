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
    
    let posterImgQueue = DispatchQueue(label: "posterImg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.text = "라라랜드"
        print("seatchBar.text \(searchBar.text)")
        searchMovies()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 인증 실패 notification 등록
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopUp(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
        // 에러 팝업
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 인증 실패 notification 등록 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    @objc func showErrorPopUp(notification: NSNotification) {
        print("MovieListViewController - showErrorPopUp()")
        
        if let data = notification.userInfo?["statusCode"] {
            print("showErrorPopUp data : \(data)")
        }
    }
    
    // MARK: - Naver Movie Search API
    func searchMovies() {
        
        // searchKeyword가 없으면 return
        guard let searchKeyword = self.searchBar.text else { return }
        
        MyAlamofireManager
            .shared
            .session
            .request(MySearchRouter.searchMovies(term: searchBar.text!))
            .validate(statusCode: 200..<401)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let movieData):
                    do {
                        print("movieData\(movieData)")
                        //obj Any인 MovieData를 JSON 타입으로 변경
                        let json = try JSONSerialization.data(withJSONObject: movieData, options: .prettyPrinted)
                        print("json:\(json)")
                       
                        // JSON DECODE
                        let decodedJson = try JSONDecoder().decode(MovieSearchResult.self, from: json)

                        let movies: [MovieSearchResult.Movie] = decodedJson.items

                        for movie in movies {
                            print("movie.title: \(movie.title)")
                        }
                    } catch(let error) {
                        print("dedcode json catch error: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            })
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

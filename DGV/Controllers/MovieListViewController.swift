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
    var movies: [MovieSearchResult.Movie] = []
    
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
                        //obj Any인 movieData를 JSON 타입으로 변경
                        let json = try JSONSerialization.data(withJSONObject: movieData, options: .prettyPrinted)
                        print("json:\(json)")
                       
                        // JSON DECODE
                        let decodedJson = try JSONDecoder().decode(MovieSearchResult.self, from: json)

                        self.movies = decodedJson.items

                        for movie in self.movies {
                            print("movie.title: \(movie.title)")
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
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
                return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
        
        let movie = movies[indexPath.row]
        guard let title = movie.title, let userRating = movie.userRating, let director = movie.director, let actor = movie.actor else {
            return cell
        }
        
        // 영화 제목 레이블
        cell.titleLabel.text = title
        print("===============> \(title) \(userRating) \(director)")
        // 평점 레이블
        if userRating == "0.00" {
            cell.ratingLabel.text = "평가 없음"
        } else {
            cell.ratingLabel.text = userRating
        }
        
        // 감독 레이블
        if director == "" {
            cell.directorLabel.text = "감독 정보 없음"
        } else {
            cell.directorLabel.text = director
        }
        
        // 연기자 레이블
        if actor == "" {
            cell.actorLabel.text = "연기자 정보 없음"
        } else {
            cell.actorLabel.text = actor
        }
        
        cell.posterImgView?.image = UIImage(named: "movie_sample")
        
        return  cell
    }
    
}

extension MovieListViewController: UITableViewDelegate {
    
}

//
//  ViewController.swift
//  DGV
//
//  Created by DaHae Kim on 2021/12/02.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [MovieSearchResult.Movie] = []
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.text = ""
        
        // 검색 시작
        //        searchMovies()
        
        searchBar
            .rx.text // RxCocoa의 Observable 속성
            .orEmpty // 옵셔널이 아니도록 만듭니다.
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // 새로운 값이 이전의 값과 같은지 확인합니다.
            .filter { !$0.isEmpty } // 새로운 값이 정말 새롭다면, 비어있지 않은 쿼리를 위해 필터링합니다.
            .subscribe(onNext: { [unowned self] query in
                searchMovies(query: query)
            })
            .disposed(by: disposeBag)
        
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
    func searchMovies(query: String) {
        
        // searchKeyword가 없으면 return
        guard let searchKeyword = self.searchBar.text else { return }
        //        guard let searchKeyword = self.searchBar.text else { return }
        
        MyAlamofireManager
            .shared
            .session
            .request(MySearchRouter.searchMovies(term: query))
        //            .request(MySearchRouter.searchMovies(term: searchBar.text!))
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
        cell.titleLabel.text = title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        print("===============> \(title) \(userRating) \(director)")
        // 평점 레이블
        if userRating == "0.00" {
            cell.ratingLabel.textColor = .gray
            cell.ratingLabel.text = "평가 없음"
        } else {
            cell.ratingLabel.textColor = UIColor.label
            cell.ratingLabel.text = userRating
        }
        
        // 감독 레이블
        if director == "" {
            cell.directorLabel.textColor = .gray
            cell.directorLabel.text = "감독 정보 없음"
        } else {
            cell.directorLabel.textColor = UIColor.label
            cell.directorLabel.text = director
        }
        
        // 연기자 레이블
        if actor == "" {
            cell.actorLabel.text = "연기자 정보 없음"
            cell.actorLabel.textColor = .gray
        } else {
            cell.actorLabel.textColor = UIColor.label
            cell.actorLabel.text = actor
        }
        
        // 포스터 이미지뷰 - 비동기처리
        if let posterImg = movie.image {
            if let url = URL(string: posterImg) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        cell.posterImgView.image = UIImage(data: data!)
                    }
                }
            }
        } else {
            cell.posterImgView.image = UIImage(named: "movie_sample")
        }
        return  cell
    }
    
}

extension MovieListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? MovieDetailViewController
            if let index = sender as? Int{
                vc?.selectedTitle = movies[index].title?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                vc?.selectedRating = movies[index].userRating
                vc?.selectedDirector = movies[index].director
                vc?.selectedActor = movies[index].actor
                vc?.selectedPosterImg = movies[index].image
                vc?.selectedLink = movies[index].link
                vc?.selectedImgURL = movies[index].image
            }
        }
    }
    
}

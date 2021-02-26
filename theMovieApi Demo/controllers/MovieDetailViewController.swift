//
//  MovieDetailViewController.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import UIKit

final class MovieDetailViewController: BaseController {

    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblRelease: UILabel!
    @IBOutlet weak var lblVote: UILabel!

    @IBOutlet weak var lblSimilarMovies: UILabel!


    @IBOutlet weak private var collectionView:UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "\(SimilarMoviesCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(SimilarMoviesCollectionViewCell.self)")
        }
    }

    private var viewModel:MovieDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.callFuncToGetMovieDetail()
        viewModel.callFuncToGetSimilarMoviesDatas()
    }

    func prepareViewModel(withID:Int){

        self.viewModel =  MovieDetailViewModel(movieID: withID)
        self.viewModel.bindViewModelToController = { [weak self] in
            guard let `self` = self else { return }
            self.lblSimilarMovies.isHidden = self.viewModel.similarMovies.count <= 0
            self.collectionView.reloadData()
        }
        self.viewModel.bindMovieViewModelToController = {  [weak self] movie in
            guard let `self` = self,let movie = movie else { return }
            self.lblTitle.text = movie.title
            self.lblDesc.text = movie.detail
            self.lblVote.text = "\(movie.imdbPoint ?? 0)"
            self.lblRelease.text = movie.releaseDate
            self.navigationItem.title = movie.title
            if let poster = movie.poster{
                self.imgPoster.setMovieImage(subURL: poster )
            }
        }
        self.viewModel.onErrorHandling = { [weak self] message in
            guard let `self` = self else { return }
            self.presentSingleActionAlert(message: message)
        }
    }

    public static func getInstance(movieID:Int)->MovieDetailViewController?{
        guard let vc = UIViewController.create(type: .detail) as? MovieDetailViewController else { return nil }
        vc.prepareViewModel(withID: movieID)
        return vc
    }

    @IBAction func imdbAppend(){
        guard let imdID = viewModel.movieDetail?.imdbID, let url = URL(string: "https://www.imdb.com/title/\(imdID)") else { return }
        UIApplication.shared.open(url)
    }

}
extension MovieDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.similarMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SimilarMoviesCollectionViewCell.self)", for: indexPath) as? SimilarMoviesCollectionViewCell else { return UICollectionViewCell()}
        let data = self.viewModel.getCollectionCellViewModel(at: indexPath)
        cell.prepareWith(data)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? SimilarMoviesCollectionViewCell else { return }
        cell.loadImage()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.viewModel.similarMovies[indexPath.row]
        guard let id = data.id , let vc = MovieDetailViewController.getInstance(movieID: id ) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width/4, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

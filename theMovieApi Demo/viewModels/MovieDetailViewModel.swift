//
//  MovieDetailViewModel.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import Foundation

final class MovieDetailViewModel : NSObject {



    private(set) var similarMovies : [Movie] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }


    private(set) var movieDetail : Movie? {
        didSet {
            self.bindMovieViewModelToController(movieDetail)
        }
    }

    var bindViewModelToController : (() -> ()) = {}
    var bindMovieViewModelToController : ((Movie?) -> ()) = {_ in }
    var onErrorHandling : ((String) -> ()) = {_ in }

    var movieID = 0

    init(movieID:Int) {
        super.init()
        self.movieID = movieID
    }

    func callFuncToGetMovieDetail() {
        LoadingView.showActivityIndicator()
        MovieDetailRequest(id: self.movieID).send { (movieReponse, err) in
            LoadingView.hideActivityIndicator()
            if let err = err {
                self.onErrorHandling(err.status_message ?? Definations.defaultError)
            }
            guard let movie = movieReponse else { self.onErrorHandling(Definations.defaultError);  return }
            self.movieDetail = movie
        }
    }

    func callFuncToGetSimilarMoviesDatas() {
        LoadingView.showActivityIndicator()
        MoviesRequest(.similarMovies(self.movieID)).send { (movieReponse, err) in
            LoadingView.hideActivityIndicator()
            if let err = err {
                self.onErrorHandling(err.status_message ?? Definations.defaultError)
            }
            self.similarMovies = movieReponse?.results ?? []
        }
    }


    func getCollectionCellViewModel(at indexPath:IndexPath) -> MoviePosterCollectionViewModel{
        return MoviePosterCollectionViewModel(with: similarMovies[indexPath.row])
    }



}


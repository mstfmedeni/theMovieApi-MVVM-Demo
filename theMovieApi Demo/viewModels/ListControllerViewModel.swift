//
//  ListControllerViewModel.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import Foundation


final class ListControllerViewModel : NSObject {

    

    private(set) var nowPlayingDatas : [Movie] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }

    private(set) var upComingDatas : [Movie] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }

    var bindViewModelToController : (() -> ()) = {}
    var onErrorHandling : ((String) -> ()) = {_ in }

    override init() {
        super.init()
        callFuncToGetNowPlayingDatas()
        callFuncToGetUpComingDatas()
    }

    func callFuncToGetNowPlayingDatas() {
        LoadingView.showActivityIndicator()
        MoviesRequest(.nowPlaying).send { (movieReponse, err) in
            LoadingView.hideActivityIndicator()
            if let err = err {
                self.onErrorHandling(err.status_message ?? Definations.defaultError)
            }
            self.nowPlayingDatas = movieReponse?.results ?? []
        }
    }

    func callFuncToGetUpComingDatas() {
        LoadingView.showActivityIndicator()
        MoviesRequest(.upComing).send { (movieReponse, err) in
            LoadingView.hideActivityIndicator()
            if let err = err {
                self.onErrorHandling(err.status_message ?? Definations.defaultError)
            }
            self.upComingDatas = movieReponse?.results ?? []
        }
    }
    func getTableCellViewModel(at indexPath:IndexPath) -> MovieTableCellViewModel{
        return MovieTableCellViewModel(with: upComingDatas[indexPath.row])
    }

    func getCollectionCellViewModel(at indexPath:IndexPath) -> MoviePosterCollectionViewModel{
        return MoviePosterCollectionViewModel(with: nowPlayingDatas[indexPath.row])
    }

    
    
}


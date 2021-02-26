//
//  SearchControllerViewMode.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import Foundation


final class SearchControllerViewModel : NSObject {


    private(set) var datas : [Movie] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }

    private var searching:Bool = false

    var bindViewModelToController : (() -> ()) = {}
    var onErrorHandling : ((String) -> ()) = {_ in }


    func callFuncToGetSearch(keyword:String) {
        if !keyword.isEmpty && keyword.split(separator: " ").count >= 2 && !searching{
            searching.toggle()
            LoadingView.showActivityIndicator()
            MoviesRequest(.search(keyword)).send { (movieReponse, err) in
                LoadingView.hideActivityIndicator()
                self.searching.toggle()
                if let err = err {
                    self.onErrorHandling(err.status_message ?? Definations.defaultError)
                }
                self.datas = movieReponse?.results ?? []
            }
        }
    }

    func getData(at indexPath:IndexPath) -> Movie{
        return  datas[indexPath.row]
    }

}

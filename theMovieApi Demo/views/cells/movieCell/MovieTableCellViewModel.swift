//
//  MovieTableCellViewModel.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import Foundation

struct MovieTableCellViewModel {
    var title:String
    var desc:String
    var date:String
    var imageUrl:String

    init(with movie:Movie) {
        self.title = movie.title.def
        self.desc = movie.detail.def
        self.date = movie.releaseDate.def
        self.imageUrl = movie.smallImage.def
    }
  
}

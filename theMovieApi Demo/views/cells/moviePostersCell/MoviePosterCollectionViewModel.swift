//
//  MoviePosterCollectionViewModel.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import Foundation

struct MoviePosterCollectionViewModel {
    var title:String
    var imageUrl:String

    init(with movie:Movie) {
        self.title = movie.title.def
         self.imageUrl = movie.smallImage.def
    }
}


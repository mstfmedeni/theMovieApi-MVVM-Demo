//
//  MovieRequests.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import Foundation



class MoviesRequest:ARTRequest<ApiArrayResponse<Movie>> {

    enum MoviesRequestType {
        case nowPlaying
        case upComing
        case search(String)
        case similarMovies(Int)
    }

    init(_ type:MoviesRequestType) {
        super.init()
        switch type {
        case .nowPlaying:
            path = RequestPath.nowPlaying()
        case .upComing:
            path = RequestPath.upComing()
        case .search(let keyword):
            path = RequestPath.search(keyword: keyword)
        case .similarMovies(let id):
            path = RequestPath.similarMovie(id: id)
        }
    }

}

class MovieDetailRequest:ARTRequest<Movie> {

    init(id:Int) {
        super.init()
        path = RequestPath.detail(id: id)
    }

}


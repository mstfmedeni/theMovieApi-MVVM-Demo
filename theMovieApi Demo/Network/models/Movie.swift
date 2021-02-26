//
//  Movie.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import Foundation

struct Movie: ARTCodable {
    let id:Int?
    let title:String?
    let detail:String?
    let imdbPoint:Double?
    let poster:String?
    let smallImage:String?
    let releaseDate:String?
    let imdbID:String?
    let tagline:String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case detail = "overview"
        case imdbPoint = "vote_average"
        case poster = "poster_path"
        case smallImage = "backdrop_path"
        case releaseDate = "release_date"
        case imdbID = "imdb_id"
        case tagline = "tagline"
    }
    
}

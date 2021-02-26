//
//  BaseResponse.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import Foundation

struct ApiArrayResponse<T:ARTCodable>: ARTCodable {
    let results: [T]?
    let page:Int?
    let total_pages:Int?
    let total_results:Int?
}




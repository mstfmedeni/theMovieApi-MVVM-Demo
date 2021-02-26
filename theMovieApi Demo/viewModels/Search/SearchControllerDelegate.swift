//
//  SearchControllerDelegate.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import Foundation

protocol SearchControllerDelegate {
    func movieSelected(data:Movie)
    func pageClosed()
    func handleFail(error:String)
    
}

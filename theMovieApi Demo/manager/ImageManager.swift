//
//  ImageManager.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import Foundation
import Kingfisher

final class ImageManager{
    private static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    static func getImageFullUrl(_ subUrl:String)->URL? {
        guard let url = URL(string: "\(imageBaseURL)\(subUrl)?api_key=4121d530cf5920e4d009cb2118bf75de") else { return nil}
        return url
    }

}

extension UIImageView{
    func setMovieImage(subURL:String){
        guard let url = ImageManager.getImageFullUrl(subURL) else { return }
        self.kf.setImage(with: url)
    }
}

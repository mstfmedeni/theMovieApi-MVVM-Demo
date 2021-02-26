//
//  SimilarMoviesCollectionViewCell.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import UIKit

class SimilarMoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var imgPoster:UIImageView!
    @IBOutlet weak private var lblTitle:UILabel!

    var viewModel:MoviePosterCollectionViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func prepareForReuse() {
        imgPoster.image = nil
    }

    func prepareWith(_ viewModel:MoviePosterCollectionViewModel){
        self.viewModel = viewModel

        lblTitle.text = viewModel.title


    }

    func loadImage(){
        guard let viewModel = viewModel else { return }
        self.imgPoster.setMovieImage(subURL: viewModel.imageUrl)
    }
}

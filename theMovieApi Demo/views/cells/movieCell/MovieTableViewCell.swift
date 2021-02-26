//
//  MovieTableViewCell.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak private var imgCover:UIImageView!
    @IBOutlet weak private var lblTitle:UILabel!
    @IBOutlet weak private var lblDesc:UILabel!
    @IBOutlet weak private var lblDate:UILabel!

    var viewModel:MovieTableCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        imgCover.image = nil
    }

    func prepareWith(_ viewModel:MovieTableCellViewModel){
        self.viewModel = viewModel

        lblTitle.text = viewModel.title
        lblDesc.text = viewModel.desc
        lblDate.text = viewModel.date
        
    }

    func loadImage(){
        guard let viewModel = viewModel else { return }
        self.imgCover.setMovieImage(subURL: viewModel.imageUrl)
    }

    
}

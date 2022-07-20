//
//  DishCollectionViewCell.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import UIKit

class DishCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var favImage: UIImageView!
    
    var data: Dish? {
        didSet {
            guard let data = data else { return }
            mainImage.image = data.dishImage
            title.text = data.dishName
            price.text = data.dishPrice
            favImage.image = data.dishFavImage
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

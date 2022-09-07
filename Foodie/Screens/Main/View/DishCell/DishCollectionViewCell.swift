//
//  DishCollectionViewCell.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import UIKit

class DishCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    
    // MARK: - Variable for Data Set On Cell
    var data: Food? {
        didSet {
            guard let data = data else { return }
//            mainImage.image = data.dishImage
            guard let imgUrl =  data.foodImgURL else { return }
            
            mainImage.loadImageUsingCache(withUrl: imgUrl)
            title.text = data.foodName
            price.text = "\(data.price) Lari"
            favImage.image = UIImage(systemName: "heart.fill")
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

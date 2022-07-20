//
//  RestaurantsCollectionViewCell.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import UIKit

class RestaurantsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var restaurantImage: UIImageView!
    
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var restaurantRating: UILabel!
    
    @IBOutlet weak var distanceFromRestaurant: UILabel!
    
    @IBOutlet weak var restaurantIsFavouriteImage: UIImageView!
    
    
    var data: Restaurant? {
        didSet {
            guard let data = data else { return }

            restaurantRating.text = data.rating
            restaurantName.text = data.name
            restaurantIsFavouriteImage.image = data.favouriteImage
            restaurantImage.image = data.mainImage
            distanceFromRestaurant.text = data.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

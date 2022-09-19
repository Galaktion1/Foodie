//
//  RestaurantsCollectionViewCell.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import UIKit

class RestaurantsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantRating: UILabel!
    @IBOutlet weak var distanceFromRestaurant: UILabel!
    @IBOutlet weak var favButtonOutlet: UIButton!
    
    // MARK: - Variables
    static let identifier = String(describing: RestaurantsCollectionViewCell.self)
    private let userDefaultsKeyForFavouriteRestaurantIds: String = "favRestaurantsIds"
    var isFavourite = false {
        didSet {
            if isFavourite { favButtonOutlet.setImage(FavoriteIndicatorImage.fillHeartImage, for: .normal) }
            else {favButtonOutlet.setImage(FavoriteIndicatorImage.emptyHeartImage, for: .normal) }
        }
    }
    
    private var favourityChecker: FavourityCheckerProtocol!
    var data: Restaurant? {
        didSet {
            guard let data = data else { return }
            
            restaurantRating.text = data.rating.visualizeRating()
            restaurantName.text = data.name
    
            guard let imgUrl =  data.restaurantImg else { return }
            restaurantImage.loadImageUsingCache(withUrl: imgUrl)
            if let distance = data.distance {
                distanceFromRestaurant.text = distance + "KM Away"
            }
            
            favourityChecker = FavourityChecker(isFavourite: isFavourite, data: data)
            isFavourite = favourityChecker.checkIfFav(id: data.id)
        }
    }

    
    // MARK: - IBActions
    @IBAction func favButton(_ sender: UIButton) {
        isFavourite = favourityChecker.favButton()
    }
}

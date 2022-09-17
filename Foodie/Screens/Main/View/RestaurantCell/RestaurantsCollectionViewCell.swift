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
    var isFavourite = false
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
        }
    }

    
    // MARK: - IBActions
    @IBAction func favButton(_ sender: UIButton) {
        guard let data = data else { return }
        var favouriteRestaurantIds = UserDefaults.standard.array(forKey: userDefaultsKeyForFavouriteRestaurantIds) as? [Int] ?? []

        isFavourite.toggle()
        
        if isFavourite {
            sender.setImage(FavoriteIndicatorImage.fillHeartImage, for: .normal)
            
            favouriteRestaurantIds.append(data.id)
            UserDefaults.standard.set(favouriteRestaurantIds, forKey: userDefaultsKeyForFavouriteRestaurantIds)
            
        } else {
            if let index = favouriteRestaurantIds.firstIndex(of: data.id) {
                sender.setImage(FavoriteIndicatorImage.emptyHeartImage, for: .normal)
                favouriteRestaurantIds.remove(at: index)
                UserDefaults.standard.set(favouriteRestaurantIds, forKey: userDefaultsKeyForFavouriteRestaurantIds)
            }
        }
    }
    
    // MARK: - Funcs
    func checkIfFav(id: Int?) {
        let favouriteRestaurantIds = UserDefaults.standard.array(forKey: userDefaultsKeyForFavouriteRestaurantIds) as? [Int] ?? []
        if let id = id {
            if favouriteRestaurantIds.contains(id) {
                favButtonOutlet.setImage(FavoriteIndicatorImage.fillHeartImage, for: .normal)
                isFavourite = true
            } else {
                favButtonOutlet.setImage(FavoriteIndicatorImage.emptyHeartImage, for: .normal)
            }
        }
    }
    
    private struct FavoriteIndicatorImage {
        static let fillHeartImage: UIImage? = UIImage(systemName: "heart.fill")
        static let emptyHeartImage: UIImage? = UIImage(systemName: "heart")
    }
}

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
    @IBOutlet weak var favButtonOutlet: UIButton!
    
    var isFavourite = false
    
    var data: Restaurant? {
        didSet {
            guard let data = data else { return }
            
            restaurantRating.text = "\(data.rating)"
            restaurantName.text = data.name
    
            guard let imgUrl =  data.restaurantImg else { return }
            restaurantImage.loadImageUsingCache(withUrl: imgUrl)
            distanceFromRestaurant.text = "7.8KM Away"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func checkIfFav(id: Int?) {
        let favouriteRestaurantIds = UserDefaults.standard.array(forKey: "favRestaurantsIds") as? [Int] ?? []
        if let id = id {
            if favouriteRestaurantIds.contains(id) {
                favButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                isFavourite = true
            } else {
                favButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    
    @IBAction func favButton(_ sender: UIButton) {
        guard let data = data else { return }
        var favouriteRestaurantIds = UserDefaults.standard.array(forKey: "favRestaurantsIds") as? [Int] ?? []

        isFavourite.toggle()
        
        if isFavourite {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
            favouriteRestaurantIds.append(data.id)
            UserDefaults.standard.set(favouriteRestaurantIds, forKey: "favRestaurantsIds")
            
        } else {
            if let index = favouriteRestaurantIds.firstIndex(of: data.id) {
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
                favouriteRestaurantIds.remove(at: index)
                UserDefaults.standard.set(favouriteRestaurantIds, forKey: "favRestaurantsIds")
            }
        }
    }
}




extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let imageCache = NSCache<NSString, UIImage>()
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
        }).resume()
    }
}

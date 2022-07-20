//
//  MainViewController.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import UIKit

class MainViewController: UIViewController{
    
    @IBOutlet weak var restaurantsCollectionView: UICollectionView!
    @IBOutlet weak var recomendedDishesCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var activeIndicatorView: UIView!
    
    @IBOutlet weak var nerbyButtonOutlet: UIButton!
    @IBOutlet weak var popularButtonOutlet: UIButton!
    @IBOutlet weak var newComboButtonOutlet: UIButton!
    @IBOutlet weak var topButtonOutlet: UIButton!
    
    let viewModel = MainViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "img_background")!)
        backgroundView.backgroundColor = .white.withAlphaComponent(0)
        nerbyButtonOutlet.tintColor = UIColor(named: "specialOrange")
        configureCollectionViews()
    }
    
    
    @IBAction func nerbyButtonAction(_ sender: UIButton) {
        viewModel.moveActiveIndicatorView(mainButton: nerbyButtonOutlet,
                                          button2: popularButtonOutlet,
                                          button3: newComboButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
    }
    
    
    @IBAction func popularButtonAction(_ sender: UIButton) {
        viewModel.moveActiveIndicatorView(mainButton: popularButtonOutlet,
                                          button2: nerbyButtonOutlet,
                                          button3: newComboButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
    }
    
    
    @IBAction func newComboButtonAction(_ sender: UIButton) {
        viewModel.moveActiveIndicatorView(mainButton: newComboButtonOutlet,
                                          button2: popularButtonOutlet,
                                          button3: nerbyButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
        
    }
    
    
    @IBAction func topButtonAction(_ sender: UIButton) {
        viewModel.moveActiveIndicatorView(mainButton: topButtonOutlet,
                                          button2: popularButtonOutlet,
                                          button3: newComboButtonOutlet,
                                          button4: nerbyButtonOutlet,
                                          indicatorView: activeIndicatorView)
    }
    
    
    
    private func configureCollectionViews() {
        let nibRestaurant = UINib(nibName: "RestaurantsCollectionViewCell", bundle: nil)
        restaurantsCollectionView.backgroundColor = UIColor(patternImage: UIImage(named: "img_background")!)
        restaurantsCollectionView.register(nibRestaurant, forCellWithReuseIdentifier: "RestaurantsCollectionViewCell")
        
        restaurantsCollectionView.delegate = self
        restaurantsCollectionView.dataSource = self
        
        
        let nibDish = UINib(nibName: "DishCollectionViewCell", bundle: nil)
        recomendedDishesCollectionView.backgroundColor = UIColor(patternImage: UIImage(named: "img_background")!)
        recomendedDishesCollectionView.register(nibDish, forCellWithReuseIdentifier: "DishCollectionViewCell")
        
        recomendedDishesCollectionView.delegate = self
        recomendedDishesCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        recomendedDishesCollectionView.setCollectionViewLayout(layout, animated: true)
    }

}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView == self.restaurantsCollectionView ? CGSize(width: 145 , height: 180 ) : CGSize(width: 105 , height: 125)
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == self.restaurantsCollectionView ? 4 : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.restaurantsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantsCollectionViewCell", for: indexPath) as! RestaurantsCollectionViewCell
            
            cell.data = Restaurant(name: "Raw Bar",
                                   rating: "🔴🔴🔴🔴🔴",
                                   mainImage: UIImage(named: "img_bar")!,
                                   favouriteImage: UIImage(systemName: "heart.fill")!,
                                   distance: "54.12KM Away")
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCollectionViewCell", for: indexPath) as! DishCollectionViewCell
            
            cell.data = Dish(dishImage: UIImage(named: "img_omlette")!,
                             dishName: "Omlette Paradaise",
                             dishPrice: "$ 12.25",
                             dishFavImage: UIImage(systemName: "heart.fill")!)
            
            
            return cell
        }
    }
}

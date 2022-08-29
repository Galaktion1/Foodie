//
//  MainViewController.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var restaurantsCollectionView: UICollectionView!
    @IBOutlet weak var recomendedDishesCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var activeIndicatorView: UIView!
    
    @IBOutlet weak var searchTextField: DesignableUITextField!
    @IBOutlet weak var allRestaurantsButtonOutlet: UIButton!
    @IBOutlet weak var nerbyButtonOutlet: UIButton!
    @IBOutlet weak var favouriteRestaurantsButtonOutlet: UIButton!
    @IBOutlet weak var topButtonOutlet: UIButton!
    
    let viewModel = MainViewViewModel()
    var favouriteRestaurantIds = [Int]()
    var search: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchRestaurantsData()
        favouriteRestaurantIds = UserDefaults.standard.array(forKey: "favRestaurantsIds") as? [Int] ?? []

        self.scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "img_background")!)
        backgroundView.backgroundColor = .clear
        allRestaurantsButtonOutlet.tintColor = CustomColors.specialOrangeColor
        configureCollectionViews()
        
        searchTextField.delegate = self
        
        collectionViewsReloading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restaurantsCollectionView.reloadData()  // სხვა სქრინიდან ყოველი დაბრუნებისას განახლდეს ინფო, რადგან მომხმარებელმა შესაძლოა დააფავორიტოს რესტორანი.
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    deinit {
        print("mainvc deinited")
    }
    
    func collectionViewsReloading() {
        viewModel.reloadCollectionView = { [weak self] in
            self?.restaurantsCollectionView.reloadData()
            self?.recomendedDishesCollectionView.reloadData()
        }
    }
    
    @IBAction func allRestaurantsButtonAction(_ sender: UIButton) {
        viewModel.setAllRestaurants()
        viewModel.moveActiveIndicatorView(mainButton: allRestaurantsButtonOutlet,
                                          button2: nerbyButtonOutlet,
                                          button3: favouriteRestaurantsButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
    }
    
    
    @IBAction func nerbyButtonAction(_ sender: UIButton) {
        viewModel.moveActiveIndicatorView(mainButton: nerbyButtonOutlet,
                                          button2: allRestaurantsButtonOutlet,
                                          button3: favouriteRestaurantsButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
    }
    
    
    @IBAction func favouriteRestaurantsButtonAction(_ sender: UIButton) {
        viewModel.setFavouriteRestaurants()
        viewModel.moveActiveIndicatorView(mainButton: favouriteRestaurantsButtonOutlet,
                                          button2: nerbyButtonOutlet,
                                          button3: allRestaurantsButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
        
    }
    
    
    @IBAction func topButtonAction(_ sender: UIButton) {
        viewModel.setTopAllRestaurants()
        viewModel.moveActiveIndicatorView(mainButton: topButtonOutlet,
                                          button2: nerbyButtonOutlet,
                                          button3: favouriteRestaurantsButtonOutlet,
                                          button4: allRestaurantsButtonOutlet,
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
        collectionView == self.restaurantsCollectionView ? viewModel.numberOfItemsInSection() : viewModel.numberOfItemsInSection()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.restaurantsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantsCollectionViewCell", for: indexPath) as! RestaurantsCollectionViewCell
            
            let currentData = viewModel.restaurantsCellForRowAt(indexPath: indexPath)
  
            cell.data = currentData
            cell.checkIfFav(id: currentData.id)
            
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCollectionViewCell", for: indexPath) as! DishCollectionViewCell
            
            cell.data = viewModel.foodsCellForItemAt(indexPath: indexPath)
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.restaurantsCollectionView {
            let sb = UIStoryboard(name: "Restaurant", bundle: Bundle.main)
            guard let vc = sb.instantiateViewController(withIdentifier: "RestaurantViewController") as? RestaurantViewController else { return }

            
            
            vc.data = viewModel.restaurantsCellForRowAt(indexPath: indexPath)
            vc.id = viewModel.restaurantsCellForRowAt(indexPath: indexPath).id
            if let imgURLString = viewModel.getRestaurantImageURL(indexPath: indexPath) {
                vc.mainImageURLString = imgURLString
            }
                        
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}



extension MainViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var filtered = [Restaurant]()
     
        if (searchTextField.text?.count)! != 0 {
            filtered.removeAll()
            for each in viewModel.specialRestaurantsArray {
                let range = each.name!.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    filtered.append(each)
                }
            }
            viewModel.specialRestaurantsArray = filtered
        }
        
        return true
    }
}


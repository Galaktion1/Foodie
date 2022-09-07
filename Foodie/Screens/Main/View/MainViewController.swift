//
//  MainViewController.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import UIKit

class MainViewController: UIViewController, Storyboarded {
    // MARK: - Outlets
    @IBOutlet weak var restaurantsCollectionView: UICollectionView!
    @IBOutlet weak var recomendedDishesCollectionView: UICollectionView!
    
    @IBOutlet weak var helloToUserLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var activeIndicatorView: UIView!
    
    @IBOutlet weak var searchTextField: DesignableUITextField!
    @IBOutlet weak var allRestaurantsButtonOutlet: UIButton!
    @IBOutlet weak var nerbyButtonOutlet: UIButton!
    @IBOutlet weak var favouriteRestaurantsButtonOutlet: UIButton!
    @IBOutlet weak var topButtonOutlet: UIButton!
    
    
    // MARK: - Variables
    let viewModel = MainViewViewModel()
    var favouriteRestaurantIds = [Int]()
    var search: String = ""
    var coordinator: MainViewCoordinator?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchRestaurantsData()
        favouriteRestaurantIds = UserDefaults.standard.array(forKey: "favRestaurantsIds") as? [Int] ?? []

        configureCollectionViews()
        allRestaurantsButtonOutlet.tintColor = CustomColors.specialOrangeColor
        restaurantsCollectionView.backgroundColor = UIColor(patternImage: CustomImages.backgroundImage!)
        recomendedDishesCollectionView.backgroundColor = UIColor(patternImage: CustomImages.backgroundImage!)
        searchTextField.delegate = self
        collectionViewsReloading()
        addBadge(itemvalue: 0)
        getUsername()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restaurantsCollectionView.reloadData()  // სხვა სქრინიდან ყოველი დაბრუნებისას განახლდეს ინფო, რადგან მომხმარებელმა შესაძლოა დააფავორიტოს რესტორანი.
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.backgroundColor = UIColor(patternImage: CustomImages.backgroundImage!)
        backgroundView.backgroundColor = .clear
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    deinit {
        print("mainvc deinited")
    }
    
    // MARK: - IBActions
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
    
    
    // MARK: - Funcs
    private func getUsername() {
        viewModel.getUsername()
        viewModel.getName = { [weak self] username in
            self?.helloToUserLabel.text = "Hello \(username.capitalized), Welcome back!"
        }
    }
    
    
    private func addBadge(itemvalue: Int) {
        
        let badgeCount = UILabel(frame: CGRect(x: 18, y: -05, width: 20, height: 20))

        badgeCount.layer.borderColor = UIColor.clear.cgColor
        badgeCount.layer.borderWidth = 2
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = .red
        badgeCount.text = "\(itemvalue)"

        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        rightButton.setBackgroundImage(UIImage(systemName: "bag"), for: .normal)
        rightButton.addSubview(badgeCount)
        if itemvalue == 0 {
            rightButton.tintColor = .gray
        }
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(rightButton)

        NSLayoutConstraint.activate([
            rightButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -30),
            rightButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10)
        ])
    }
    
    func collectionViewsReloading() {
        viewModel.reloadCollectionView = { [weak self] in
            self?.restaurantsCollectionView.reloadData()
            self?.recomendedDishesCollectionView.reloadData()
        }
    }
    
    
    private func configureCollectionViews() {
        let nibRestaurant = UINib(nibName: "RestaurantsCollectionViewCell", bundle: nil)
        restaurantsCollectionView.register(nibRestaurant, forCellWithReuseIdentifier: "RestaurantsCollectionViewCell")
        restaurantsCollectionView.delegate = self
        restaurantsCollectionView.dataSource = self
        
        let nibDish = UINib(nibName: "DishCollectionViewCell", bundle: nil)
        recomendedDishesCollectionView.register(nibDish, forCellWithReuseIdentifier: "DishCollectionViewCell")
        recomendedDishesCollectionView.delegate = self
        recomendedDishesCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        recomendedDishesCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}


// MARK: - Collection View Extension
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView == self.restaurantsCollectionView ? CGSize(width: 145 , height: 180 ) : CGSize(width: 105 , height: 125)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection()
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
            let restaurant = viewModel.restaurantsCellForRowAt(indexPath: indexPath)
            
            coordinator?.moveToMenu(of: restaurant)
        }
    }
}


extension MainViewController: UITextFieldDelegate {
    
    // MARK: - Text Field Delegate Function For Each Changes In Textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var filtered = [Restaurant]()
     
        if (searchTextField.text?.count)! != 0 {
            filtered.removeAll()
            for each in viewModel.specialRestaurantsArray {
                let range = each.name.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    filtered.append(each)
                }
            }
            viewModel.specialRestaurantsArray = filtered
        }
        return true
    }
}


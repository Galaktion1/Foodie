//
//  MainViewController.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import UIKit
import GoogleMaps
import CoreLocation

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
    @IBOutlet weak var nearbyButtonOutlet: UIButton!
    @IBOutlet weak var favouriteRestaurantsButtonOutlet: UIButton!
    @IBOutlet weak var topButtonOutlet: UIButton!
    
    //MARK: - UIComponent
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    // MARK: - Variables
    private let viewModel = MainViewViewModel()
    var coordinator: MainViewCoordinator?
    private let locationManager = CLLocationManager()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchRestaurantsData()
        configureLocationManager()
        configureCollectionViews()
        allRestaurantsButtonOutlet.tintColor = CustomColors.specialOrangeColor
        restaurantsCollectionView.backgroundColor = .clear
        recomendedDishesCollectionView.backgroundColor = UIColor(patternImage: CustomImages.backgroundImage!)
        searchTextField.delegate = self
        collectionViewsReloading()
        getUsername()
        logOutButton.addTarget(self, action: #selector(logOutFunctionality), for: .touchUpInside)
        logOut()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restaurantsCollectionView.reloadData()  // სხვა სქრინიდან ყოველი დაბრუნებისას განახლდეს ინფო, რადგან მომხმარებელმა შესაძლოა დააფავორიტოს რესტორანი.
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        confLogOutButton()
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
                                          button2: nearbyButtonOutlet,
                                          button3: favouriteRestaurantsButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
    }
    
    
    @IBAction func nearbyButtonAction(_ sender: UIButton) {
        viewModel.sortByNearby()
        viewModel.moveActiveIndicatorView(mainButton: nearbyButtonOutlet,
                                          button2: allRestaurantsButtonOutlet,
                                          button3: favouriteRestaurantsButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
    }
    
    
    @IBAction func favouriteRestaurantsButtonAction(_ sender: UIButton) {
        viewModel.setFavouriteRestaurants()
        viewModel.moveActiveIndicatorView(mainButton: favouriteRestaurantsButtonOutlet,
                                          button2: nearbyButtonOutlet,
                                          button3: allRestaurantsButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
        
    }
    
    
    @IBAction func topButtonAction(_ sender: UIButton) {
        viewModel.sortByTopAllRestaurants()
        viewModel.moveActiveIndicatorView(mainButton: topButtonOutlet,
                                          button2: nearbyButtonOutlet,
                                          button3: favouriteRestaurantsButtonOutlet,
                                          button4: allRestaurantsButtonOutlet,
                                          indicatorView: activeIndicatorView)
    }
    
    
    // MARK: - Funcs
    @objc func logOutFunctionality() {
        viewModel.logOut()
    }
    
    private func logOut() {
        viewModel.logOutUser = { [weak self] in
            let sb = UIStoryboard(name: "SignIn&SignUp", bundle: Bundle.main)
            let nav = UINavigationController(rootViewController: sb.instantiateViewController(withIdentifier: "SignInViewController"))
            self?.view.window?.rootViewController = nav
            self?.view.window?.makeKeyAndVisible()
        }
    }
    
    private func confLogOutButton() {
        view.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            logOutButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 5),
            logOutButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            logOutButton.widthAnchor.constraint(equalToConstant: 30),
            logOutButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureLocationManager() {
        viewModel.setLocationManagerConfigurations = { [weak self] in
            self?.locationManager.delegate = self
            self?.locationManager.requestWhenInUseAuthorization()
            self?.locationManager.startUpdatingLocation()
            self?.locationManager.distanceFilter = 500 // distance changes you want to be informed about (in meters)
            self?.locationManager.desiredAccuracy = 10 // biggest approximation you tolerate (in meters)
            self?.locationManager.activityType = .automotiveNavigation // .automotiveNavigation will stop the updates when the device is not moving
        }
    }
    
    private func getUsername() {
        viewModel.getUsername()
        viewModel.getName = { [weak self] username in
            self?.helloToUserLabel.text = "Hello \(username.capitalized), Welcome back!"
        }
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
        else if collectionView == self.recomendedDishesCollectionView {
            guard let food = viewModel.foodsCellForItemAt(indexPath: indexPath) else { return }
            
            coordinator?.seeInfo(about: food)
        }
    }
}


extension MainViewController: UITextFieldDelegate {
    
    // MARK: - Text Field Delegate Function For Each Changes In Textfield.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var filtered = [Restaurant]()     // esec viewModelshi
     
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

// MARK: - LocationManager Delegate Extension To Get Current Location.
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.first?.coordinate else { return }
        viewModel.getDistance(currentLocation: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
    }
}

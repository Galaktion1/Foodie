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
    private var viewModel: (MainViewViewModelProtocol & CollectionViewHelperProtocol)!
    var coordinator: MainViewCoordinatorProtocol?
    private let locationManager = CLLocationManager()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        viewModel.getRestaurants()
        configureLocationManager()
        configureCollectionViews()
        searchTextField.delegate = self
        collectionViewsReloading()
        getUsername()
        allRestaurantsButtonOutlet.tintColor = CustomColors.specialOrangeColor
        logOutButton.addTarget(self, action: #selector(logOutFunctionality), for: .touchUpInside)
        self.hideKeyboardWhenTappedAround()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restaurantsCollectionView.reloadData()  // სხვა სქრინიდან ყოველი დაბრუნებისას განახლდეს ინფო, რადგან მომხმარებელმა შესაძლოა დააფავორიტოს რესტორანი.
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
   
    // MARK: - IBActions
    @IBAction func allRestaurantsButtonAction(_ sender: UIButton) {
        viewModel.setCollectionViewContent(about: .all)
        moveActiveIndicatorView(mainButton: allRestaurantsButtonOutlet,
                                          button2: nearbyButtonOutlet,
                                          button3: favouriteRestaurantsButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
    }
    
    
    @IBAction func nearbyButtonAction(_ sender: UIButton) {
        viewModel.setCollectionViewContent(about: .nearby)
        moveActiveIndicatorView(mainButton: nearbyButtonOutlet,
                                          button2: allRestaurantsButtonOutlet,
                                          button3: favouriteRestaurantsButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
    }
    
    
    @IBAction func favouriteRestaurantsButtonAction(_ sender: UIButton) {
        viewModel.setCollectionViewContent(about: .favourite)
        moveActiveIndicatorView(mainButton: favouriteRestaurantsButtonOutlet,
                                          button2: nearbyButtonOutlet,
                                          button3: allRestaurantsButtonOutlet,
                                          button4: topButtonOutlet,
                                          indicatorView: activeIndicatorView)
        
    }
    
    
    @IBAction func topButtonAction(_ sender: UIButton) {
        viewModel.setCollectionViewContent(about: .top)
        moveActiveIndicatorView(mainButton: topButtonOutlet,
                                          button2: nearbyButtonOutlet,
                                          button3: favouriteRestaurantsButtonOutlet,
                                          button4: allRestaurantsButtonOutlet,
                                          indicatorView: activeIndicatorView)
    }
    
    // MARK: - Selector Method
    @objc func logOutFunctionality() {
        viewModel.logOut()
        viewModel.logOutUser = { [weak self] in
            let nav = self?.coordinator?.logOut()
            self?.view.window?.rootViewController = nav
            self?.view.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: - Funcs
    private func configureViewModel() {
        let restaurantManager = RestaurantManager()
        viewModel = MainViewViewModel(with: restaurantManager)
    }
    private func configureUI() {
        restaurantsCollectionView.backgroundColor = .clear
        recomendedDishesCollectionView.backgroundColor = UIColor(patternImage: CustomImages.backgroundImage!)
        confLogOutButton()
        self.scrollView.backgroundColor = UIColor(patternImage: CustomImages.backgroundImage!)
        backgroundView.backgroundColor = .clear
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
    
    
    private func collectionViewsReloading() {
        viewModel.reloadCollectionView = { [weak self] in
            self?.restaurantsCollectionView.reloadData()
            self?.recomendedDishesCollectionView.reloadData()
        }
    }
    
    
    private func configureCollectionViews() {
        let nibRestaurant = UINib(nibName: RestaurantsCollectionViewCell.identifier, bundle: nil)
        restaurantsCollectionView.register(nibRestaurant, forCellWithReuseIdentifier: RestaurantsCollectionViewCell.identifier)
        restaurantsCollectionView.delegate = self
        restaurantsCollectionView.dataSource = self
        
        let nibDish = UINib(nibName: DishCollectionViewCell.identifier, bundle: nil)
        recomendedDishesCollectionView.register(nibDish, forCellWithReuseIdentifier: DishCollectionViewCell.identifier)
        recomendedDishesCollectionView.delegate = self
        recomendedDishesCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        recomendedDishesCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func moveActiveIndicatorView(mainButton: UIButton, button2: UIButton, button3: UIButton, button4: UIButton, indicatorView: UIView) {
        mainButton.tintColor = CustomColors.specialOrangeColor
        button2.tintColor = .systemGray
        button3.tintColor = .systemGray
        button4.tintColor = .systemGray
        
        let xCoordinant = mainButton.frame.origin.x
        let mainButtonWidth = mainButton.frame.width
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options:[], animations: {
            indicatorView.transform = CGAffineTransform(translationX: xCoordinant, y: 0)
            indicatorView.frame.size.width = mainButtonWidth
        }, completion: nil)
    }
}


// MARK: - Collection View Extension
extension MainViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.restaurantsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantsCollectionViewCell.identifier, for: indexPath) as! RestaurantsCollectionViewCell
            
            let currentData = viewModel.restaurantsCellForRowAt(indexPath: indexPath)
  
            cell.data = currentData
//            cell.checkIfFav(id: currentData.id)
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCollectionViewCell.identifier, for: indexPath) as! DishCollectionViewCell
            
            cell.data = viewModel.foodsCellForItemAt(indexPath: indexPath)
            
            return cell
        }
    }
}


extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView == self.restaurantsCollectionView ? CGSize(width: 145 , height: 180 ) : CGSize(width: 105 , height: 125)
    }
}


extension MainViewController: UICollectionViewDelegate {
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
        viewModel.searchRestaurant(text: textField.text)
    }
}

// MARK: - LocationManager Delegate Extension To Get Current Location.
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.first?.coordinate else { return }
        viewModel.getDistance(currentLocation: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
    }
}

//
//  RestaurantViewController.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 23.07.22.
//

import UIKit

class RestaurantViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var causineLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var foodieRanksLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var webSiteLabel: UILabel!
    @IBOutlet weak var favButtonOutlet: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var menuStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var menuStackViewTopConstraint: NSLayoutConstraint!
    
    private var isFavourite = false
    var id: Int!
    var mainImageURLString: String!
    var data: Restaurant!
    var chosenFood: [ChosenFood] = []
    
    private let chosenFoodOrangeView: UIView = {
        let orangeView = UIView()
        orangeView.backgroundColor = CustomColors.specialOrangeColor
        orangeView.translatesAutoresizingMaskIntoConstraints = false
        orangeView.layer.cornerRadius = UIConstants.chosenFoodOrangeViewCornerRadius
        
        return orangeView
    }()
    
    private let chosenFoodAmountBackgroundView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 15,
                            y: 15,
                            width: UIConstants.chosenFoodAmountBackgroundViewWidthAndHeight,
                            height: UIConstants.chosenFoodAmountBackgroundViewWidthAndHeight)
        
        view.layer.cornerRadius = UIConstants.chosenFoodAmountBackgroundViewWidthAndHeight / 2
        view.backgroundColor = .white
        
        return view
    }()
    
    private let chosenFoodAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.chosenFoodAmountLabelFontSize)
        label.frame = CGRect(x: 10, y: 8, width: 15, height: 15)
        label.textColor = CustomColors.specialOrangeColor
        
        return label
    }()
    
    private let viewOrderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.chosenFoodAmountLabelFontSize + 3)
        label.frame = CGRect(x: 65, y: 20, width: 90, height: 20)
        label.textColor = .white
        label.text = "View order"
        
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: UIConstants.chosenFoodAmountLabelFontSize + 5)
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }()
    
    
    private struct UIConstants {
        static let chosenFoodOrangeViewCornerRadius: CGFloat = 25
        static let chosenFoodAmountBackgroundViewWidthAndHeight: CGFloat = 30
        static let chosenFoodAmountLabelFontSize: CGFloat = 15
        static let heightForRowAt: CGFloat = 70
        static let numberOfRowsInSection = 1
        static let heightForHeaderInSection: CGFloat = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataToUIElements(data)
        checkIfFav(id: id)
        configureTableView()
        self.scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "img_background")!)
        backgroundView.backgroundColor = .clear
        
        loadMainImage(with: mainImageURLString)
    }
    
    
    deinit {
        print("restaurant deinited")
    }
    
   
    
    @IBAction func favButttonAction(_ sender: UIButton) {
        guard let data = data else { return }
        var favouriteRestaurantIds = UserDefaults.standard.array(forKey: "favRestaurantsIds") as? [Int] ?? []
        
        isFavourite.toggle()
        
        if isFavourite {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
            favouriteRestaurantIds.append(data.id!)
            UserDefaults.standard.set(favouriteRestaurantIds, forKey: "favRestaurantsIds")
            
        } else {
            if let index = favouriteRestaurantIds.firstIndex(of: data.id!) {
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
                favouriteRestaurantIds.remove(at: index)
                UserDefaults.standard.set(favouriteRestaurantIds, forKey: "favRestaurantsIds")
            }
        }
    }
    
    
    
    @IBAction func seeAllButton(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "See All " {
            let height : CGFloat = 15
            self.menuStackViewTopConstraint.constant = height
            self.menuStackViewHeight.constant = 630
            
            sender.setTitle("See Less", for: .normal)
            menuTableView.isScrollEnabled = true
            self.infoStackView?.isHidden = true
            UIView.animate(withDuration: 0.7, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            let height: CGFloat = 385
            self.menuStackViewTopConstraint.constant = height
            sender.setTitle("See All ", for: .normal)
            self.menuStackViewHeight.constant = 219
            
            menuTableView.isScrollEnabled = false
            
            UIView.animate(withDuration: 0.7, animations: {
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseInOut, animations: {
                self.infoStackView?.isHidden = false
            }, completion: nil)
            
        }
    }
    
    private func configureTableView() {
        let nib = UINib(nibName: "MenuTableViewCell", bundle: Bundle.main)
        menuTableView.register(nib, forCellReuseIdentifier: "MenuTableViewCell")
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        menuTableView.backgroundColor = .clear
    }
    
    private func setDataToUIElements(_ data: Restaurant) {
        titleLabel.text = data.name
        ratingLabel.text = "🔴🔴🔴🔴🔴" // !!!
        causineLabel.text = "Georgian"   //!!!
        //            foodieRanksLabel.text = ""  // !!!
        addressLabel.text = data.descriptions?.address
        phoneLabel.text = data.descriptions?.phone
        emailLabel.text = data.descriptions?.mail
        webSiteLabel.text = data.descriptions?.website
    }
    
    private func checkIfFav(id: Int?) {
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
    
    private func loadMainImage(with url: String) {
        mainImageView.loadImageUsingCache(withUrl: url)
    }
    
    private func configureOrangeView() {
        addOrangeViewSubviewsAndGesture()
        
        NSLayoutConstraint.activate([
            chosenFoodOrangeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            chosenFoodOrangeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chosenFoodOrangeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chosenFoodOrangeView.heightAnchor.constraint(equalToConstant: 60),
            
            totalPriceLabel.topAnchor.constraint(equalTo: chosenFoodOrangeView.topAnchor, constant: 20),
            totalPriceLabel.trailingAnchor.constraint(equalTo: chosenFoodOrangeView.trailingAnchor, constant: -20),
            totalPriceLabel.widthAnchor.constraint(equalToConstant: 120),
            totalPriceLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func addOrangeViewSubviewsAndGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        chosenFoodOrangeView.addGestureRecognizer(tap)
        
        chosenFoodAmountBackgroundView.addSubview(chosenFoodAmountLabel)
        chosenFoodOrangeView.addSubview(chosenFoodAmountBackgroundView)
        chosenFoodOrangeView.addSubview(viewOrderLabel)
        chosenFoodOrangeView.addSubview(totalPriceLabel)
        view.addSubview(chosenFoodOrangeView)
    }
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer?) {
        let sb = UIStoryboard(name: "Cart", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else { return }
        _ = vc.view
        vc.foods = chosenFood
        vc.address = data.descriptions?.address
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func checkButtonAnimation(button: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
            button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            
            button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
                button.transform = .identity
            }, completion: nil)
        }
    }
}


extension RestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIConstants.heightForRowAt
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.foods?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UIConstants.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UIConstants.heightForHeaderInSection
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated: true)
    //
    //        let sb = UIStoryboard(name: "PagerViewStoryboard", bundle: nil)
    //        let vc = sb.instantiateViewController(withIdentifier: "PagerViewViewController") as! PagerViewViewController
    //
    //        UserDefaults.standard.setValue(indexPath.section, forKey: "numberOfSectionTappedInMyTask")
    //
    //        let data = viewModel.cellForRowAt(indexPath: indexPath)
    //        vc.data = data
    //
    //        vc.navigationItem.largeTitleDisplayMode = .never
    //        navigationController?.pushViewController(vc, animated: true)
    //    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        
        if let foods = data.foods {
            cell.contentView.layer.cornerRadius = 10
            cell.configureUIComponents(food: foods[indexPath.section])
        }
        cell.delegate = self
        
        return cell
    }
}


extension RestaurantViewController: MenuTableViewCellDelegate {
    func chosenFood(food: ChosenFood, button: UIButton) {
        if chosenFood.isEmpty {
            configureOrangeView()
            chosenFoodAmountLabel.text = "1"
            totalPriceLabel.text = "\(food.price)"
            chosenFood.append(food)
            button.isUserInteractionEnabled = false
            
            checkButtonAnimation(button: button)
        }
        else {
            checkButtonAnimation(button: button)
            button.isUserInteractionEnabled = false
            chosenFood.append(food)
            chosenFoodAmountLabel.text = "\(chosenFood.count)"
            let totalSpent = chosenFood.reduce(0.0) { $0 + (Double($1.price.prefix($1.price.count - 2)) ?? 0.0) }
            totalPriceLabel.text = "\(totalSpent) ₾"
        }
    }
}



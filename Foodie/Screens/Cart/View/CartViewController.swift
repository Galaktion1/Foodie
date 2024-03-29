//
//  CartViewController.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 28.07.22.
//

import UIKit
import SwiftUI

class CartViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    var address: String!
    private let viewModel = CartViewViewModel()
    var deliveryPrice = Int.random(in: 2 ... 15)
    var foodPrice = Double() {
        didSet {
            foodPrice = Double(foodPrice.format())!
        }
    }
    
    var foods: [ChosenFood]? {
        didSet {
            tableView.reloadData()
            foodPrice = calculateOrderPrice()
            orderLabel.text = "\(foodPrice) ₾"
            deliveryLabel.text = "\(deliveryPrice) ₾"
            summaryLabel.text = "\(foodPrice + Double(deliveryPrice)) ₾"
        }
    }
    
    func setDataToUIElements() {
        tableView.reloadData()
        foodPrice = calculateOrderPrice()
        orderLabel.text = "\(foodPrice) ₾"
        deliveryLabel.text = "\(deliveryPrice) ₾"
        summaryLabel.text = "\(foodPrice + Double(deliveryPrice)) ₾"
    }
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your cart is ready to go"
        configureTableView()
        
        setDataToUIElements()
    }
    
    deinit {
        print("cartView deinited")
    }
    
    // MARK: - IBActions
    @IBAction func proceedButton(_ sender: UIButton) {
        if let navigationController = navigationController {
            let swiftUIController = UIHostingController(rootView: PurchaseView(vc: navigationController, foodPrice: foodPrice, deliveryPrice: Double(deliveryPrice), summaryPrice: foodPrice + Double(deliveryPrice), foods: foods ?? []))
            navigationController.pushViewController(swiftUIController, animated: true)
        }
    }
    
    // MARK: - Funcs
    private func calculateOrderPrice() -> Double {
        foods?.reduce(0.0, { partialResult, food in
            partialResult + (Double(food.price.prefix(food.price.count - 2)) ?? 0.0)
        }) ?? 0.0
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: ChosenFoodTableViewCell.identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: ChosenFoodTableViewCell.identifier)
        
        let nib2 = UINib(nibName: DeliveryDetailsTableViewCell.identifier, bundle: Bundle.main)
        tableView.register(nib2, forCellReuseIdentifier: DeliveryDetailsTableViewCell.identifier)
    }
    
    
    fileprivate struct TableViewConstants {
        static let heightForRowAt: CGFloat = 70
        static let numberOfRowsInSection: Int = 1
        static let heightForHeaderInSection: CGFloat = 30
    }
}


extension CartViewController:  UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        (foods?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TableViewConstants.numberOfRowsInSection
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        switch indexPath.section {
        case foods?.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryDetailsTableViewCell.identifier) as! DeliveryDetailsTableViewCell
            
            cell.addressLabel.text = address
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChosenFoodTableViewCell.identifier) as! ChosenFoodTableViewCell
            
            if let currentElement = foods?[indexPath.section] {
                cell.setDataToElemets(img: currentElement.foodImage, title: currentElement.title, price: currentElement.price, numberOfFood: 1)
            }
            
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        TableViewConstants.heightForRowAt
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        TableViewConstants.heightForHeaderInSection
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 0, width: 140, height: 20)
        
        viewModel.identifySections(section: section, sectionCount: foods?.count ?? 0) { title in
            label.text = title
        }
        
        label.font = .systemFont(ofSize: 17)
        label.textColor = CustomColors.specialOrangeColor
        
        headerView.addSubview(label)
        
        return headerView
    }
}

extension CartViewController: ChosenFoodTableViewCellDelegate {
    func orderPriceChange(with number: Double) {
        foodPrice = foodPrice + number
        orderLabel.text = "\(foodPrice) ₾"
        summaryLabel.text = "\(foodPrice + Double(deliveryPrice)) ₾"
    }
}

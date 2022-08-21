//
//  CartViewController.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 28.07.22.
//

import UIKit
import SwiftUI

class CartViewController: UIViewController {
    var deliveryPrice = Int.random(in: 2 ... 15)
    var foodPrice = Double() {
        didSet {
            foodPrice = Double(foodPrice.format(f: ".1"))!
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
    
    var address: String!
    
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your cart is ready to go"
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ChosenFoodTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "ChosenFoodTableViewCell")
        
        let nib2 = UINib(nibName: "DeliveryDetailsTableViewCell", bundle: Bundle.main)
        tableView.register(nib2, forCellReuseIdentifier: "DeliveryDetailsTableViewCell")
    }
    
    @IBAction func proceedButton(_ sender: UIButton) {
        let swiftUIController = UIHostingController(rootView: PurchaseView(foodPrice: foodPrice, deliveryPrice: Double(deliveryPrice), summaryPrice: foodPrice + Double(deliveryPrice)))
        navigationController?.pushViewController(swiftUIController, animated: true)
    }
    
    private func calculateOrderPrice() -> Double {
        foods?.reduce(0.0, { partialResult, food in
            partialResult + (Double(food.price.prefix(food.price.count - 2)) ?? 0.0)
        }) ?? 0.0
    }
}


extension CartViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        (foods?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30.0
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 0, width: 140, height: 20)
        if section == 0 {
            label.text = "Combos"
        }
        else if section == foods?.count {
            label.text = "Delivery details"
        }
        
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(named: "specialOrange")
        
        headerView.addSubview(label)
        
        return headerView
    }
     
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == foods?.count {
            
        }
       
        switch indexPath.section {
        case foods?.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryDetailsTableViewCell") as! DeliveryDetailsTableViewCell
            
            cell.addressLabel.text = address
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChosenFoodTableViewCell") as! ChosenFoodTableViewCell
            
            if let currentElement = foods?[indexPath.section] {
                cell.setDataToElemets(img: currentElement.foodImage, title: currentElement.title, price: currentElement.price, numberOfFood: 1)
            }
            
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

extension CartViewController: ChosenFoodTableViewCellDelegate {
    func orderPriceChange(with number: Double) {
        foodPrice = foodPrice + number
        orderLabel.text = "\(foodPrice) ₾"
        summaryLabel.text = "\(foodPrice + Double(deliveryPrice)) ₾"
    }
}

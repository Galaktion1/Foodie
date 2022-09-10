//
//  MyOrdersViewController.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 08.09.22.
//

import UIKit

class MyOrdersViewController: UIViewController {
    
    
    var foods: [ChosenFood] = [ChosenFood(foodImage: UIImage(named: "img_omlette")!, title: "Omlette", price: "12.4", isChosen: true),
                               ChosenFood(foodImage: UIImage(named: "img_omlette")!, title: "Omlette", price: "12.4", isChosen: true)]
    
    // MARK: - UIElements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: UIConstants.tableViewXCordinat,
                                 y: UIConstants.tableViewYCordinat,
                                 width: UIConstants.tableViewWidth,
                                 height: UIConstants.tableViewHeight)
        
        return tableView
    }()

    
    // MARK: - Live Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "My Orders"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ChosenFoodTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "ChosenFoodTableViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
    }
    
    
    // MARK: - Private struct for ui elements constaints
    private struct UIConstants {
        private let rect = UIScreen.main.bounds
        static let tableViewXCordinat: CGFloat = 20
        static let tableViewYCordinat: CGFloat = 80
        static let tableViewWidth: CGFloat = UIScreen.main.bounds.width - 40
        static let tableViewHeight: CGFloat = UIScreen.main.bounds.height - 120
    }
}

extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        foods.count
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
        else if section == foods.count {
            label.text = "Delivery details"
        }
        
        label.font = .systemFont(ofSize: 17)
        label.textColor = CustomColors.specialOrangeColor
        
        headerView.addSubview(label)
        
        return headerView
    }
     
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChosenFoodTableViewCell") as! ChosenFoodTableViewCell
        
        
        let currentElement = foods[indexPath.section]
        cell.setDataToElemets(img: currentElement.foodImage, title: currentElement.title, price: currentElement.price, numberOfFood: 1)
        cell.configureCellForMyOrdersScene()
        cell.selectionStyle = .none
        
        return cell
        
    }
    
}

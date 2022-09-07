//
//  ChosenFoodTableViewCell.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 03.08.22.
//

import UIKit

protocol ChosenFoodTableViewCellDelegate: AnyObject {
    func orderPriceChange(with number: Double)
}

class ChosenFoodTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var foodImgView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var numberOfFood: UILabel!
    @IBOutlet weak var unchooseButtonOutlet: UIButton!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - Variables
    var foodAmount = 1
    var price: Double!
    var chosen = true
    weak var delegate: ChosenFoodTableViewCellDelegate?
    
    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    @IBAction func increaseNumberOfFood(_ sender: UIButton) {
        
        if sender.currentImage != UIImage(systemName: "checkmark.circle.fill") {
            unchooseButtonOutlet.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        
        foodAmount += 1
        
        numberOfFood.text = "\(foodAmount)"
        self.foodPrice.text = "\((Double(foodAmount) * price).format())"
        delegate?.orderPriceChange(with: price)
    }
    
    
    @IBAction func decreaseNumberOfFood(_ sender: UIButton) {
        
        if foodAmount > 0 {
            foodAmount -= 1
            if foodAmount == 0 {
                unchooseButtonOutlet.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            }
            
            numberOfFood.text = "\(foodAmount)"
            self.foodPrice.text = "\((Double(foodAmount) * price).format())"
            delegate?.orderPriceChange(with: -price)    // fasta sxvaoba
        }
    }
    
    
    @IBAction func unchooseFood(_ sender: UIButton) {
        chosen.toggle()
        
        if !chosen {
            if let priceChangedValue = Double((Double(foodAmount) * price).format()) {
                delegate?.orderPriceChange(with: -priceChangedValue)
            }
            
            sender.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        }
        else {
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            
            if let priceChangedValue = Double((Double(foodAmount) * price).format()) {
                delegate?.orderPriceChange(with: priceChangedValue)
            }
        }
    }
    
    // MARK: - Funcs
    func setDataToElemets(img: UIImage, title: String, price: String, numberOfFood: Int) {
        self.foodImgView.image = img
        self.foodTitleLabel.text = title
        self.foodPrice.text = price
        self.numberOfFood.text = "\(numberOfFood)"
        self.price = Double(price.prefix(price.count - 2))
    }
}

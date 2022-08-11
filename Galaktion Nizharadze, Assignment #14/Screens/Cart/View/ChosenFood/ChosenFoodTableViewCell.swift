//
//  ChosenFoodTableViewCell.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 03.08.22.
//

import UIKit

protocol ChosenFoodTableViewCellDelegate {
    func orderPriceChange(with number: Double)
}

class ChosenFoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodImgView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var numberOfFood: UILabel!
    @IBOutlet weak var unchooseButtonOutlet: UIButton!
    @IBOutlet weak var backView: UIView!
    
    
    var foodAmount = 1
    var price: Double!
    var chosen = true
    
    var delegate: ChosenFoodTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func increaseNumberOfFood(_ sender: UIButton) {
        
        if sender.currentImage != UIImage(systemName: "checkmark.circle.fill") {
            unchooseButtonOutlet.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        
        
        foodAmount += 1
        
        numberOfFood.text = "\(foodAmount)"
        self.foodPrice.text = "\((Double(foodAmount) * price).format(f: ".1"))"
        delegate?.orderPriceChange(with: price)
    }
    
    
    @IBAction func decreaseNumberOfFood(_ sender: UIButton) {
        
        if foodAmount > 0 {
            foodAmount -= 1
            if foodAmount == 0 {
                unchooseButtonOutlet.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            }
            
            numberOfFood.text = "\(foodAmount)"
            self.foodPrice.text = "\((Double(foodAmount) * price).format(f: ".1"))"
            delegate?.orderPriceChange(with: -price)    // fasta sxvaoba
        }
        
    }
    
    
    @IBAction func unchooseFood(_ sender: UIButton) {
        chosen.toggle()
        
        if !chosen {
            delegate?.orderPriceChange(with: -Double((Double(foodAmount) * price).format(f: ".1"))!)
            sender.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        }
        else {
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            delegate?.orderPriceChange(with: Double((Double(foodAmount) * price).format(f: ".1"))!)
        }
        
    }
    
    
    
    func setDataToElemets(img: UIImage, title: String, price: String, numberOfFood: Int) {
        self.foodImgView.image = img
        self.foodTitleLabel.text = title
        self.foodPrice.text = price
        self.numberOfFood.text = "\(numberOfFood)"
        self.price = Double(price.prefix(price.count - 2))
    }
    
    
}

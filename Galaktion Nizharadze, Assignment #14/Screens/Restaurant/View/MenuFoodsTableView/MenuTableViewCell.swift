//
//  MenuTableViewCell.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 25.07.22.
//

import UIKit

protocol MenuTableViewCellDelegate {
    func chosenFood(food: ChosenFood, button: UIButton)
}

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    @IBOutlet weak var foodDescriptionLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var isButtonChoosenOutlet: UIButton!
    
    var delegate: MenuTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func isChoosenButton(_ sender: UIButton) {
        delegate?.chosenFood(food: ChosenFood(foodImage: foodImageView.image ?? UIImage(named: "img_omlette")!, title: foodTitleLabel.text ?? "omlette", price: foodPriceLabel.text ?? "0.0", isChosen: true), button: sender)
    }
    
    
    func configureUIComponents(food: Food) {
        if let url = food.foodImgURL {
            foodImageView.loadImageUsingCache(withUrl: url)
        }

        foodTitleLabel.text = food.foodName
        foodDescriptionLabel.text = food.about
        foodPriceLabel.text = "\(food.price ?? 0) ₾"
    }
    
    
    
    
    
}

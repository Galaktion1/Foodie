//
//  DishDetailsVC.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 10.09.22.
//

import UIKit

final class DishDetailsVC: UIViewController {
    
    var data: Food?
    
    //MARK: - UIComponents
    private let mainImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let overviewBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 40
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 21)
        label.text = "Khinkali - ხინკალი"
        label.numberOfLines = 3
        
        var widthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .lessThanOrEqual, toItem: label.superview, attribute: .width, multiplier: 1.0, constant: 220)
        label.addConstraint(widthConstraint)
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CustomColors.specialOrangeColor
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "₾78.5"
        
        var widthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .lessThanOrEqual, toItem: label.superview, attribute: .width, multiplier: 1.0, constant: 60)
        label.addConstraint(widthConstraint)
        
        
        return label
    }()
    
    private let cuisineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.text = "🍽 Cuisine - "
        
        return label
    }()
    
    private let cheapDeliveryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 11
        view.backgroundColor = CustomColors.specialOrangeColor
        
        return view
    }()
    
    private let cheapDeliveryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.text = "Cheap Delivery"
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let starBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemYellow
        
        return view
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .white
        
        return imageView
    }()
    
    private let foodRankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "#1 of 250"
        
        return label
    }()
    
    
    private let rankStaticLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14)
        label.text = "Rank"
        
        return label
    }()
    
    
    private let detailsStaticLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CustomColors.specialOrangeColor
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "DETAILS"
        
        return label
    }()
    
    private let bottomLineOfDetails: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CustomColors.specialOrangeColor
        
        return view
    }()
    
    private let aboutDishTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.text = "White Dry Wine This Dry white wine is made from hand-selected “Rkatsiteli” and “Mtsvane” grape varieties in Kakheti region, Eastern Georgia. The wine is straw-colored, distinguished by refined taste. Aroma is dominated by tropic al fruit, herbal and floral tones. Recommended with salads, white meat and seafood. Serve at temperature 10-12 C."
        
        return textView
    }()
    
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOnUIElements()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureUIElementsConstraints()
    }
    
    
    //MARK: - Funcs
    private func configureRankStackView() {
        foodRankStackView.addArrangedSubview(rankLabel)
        foodRankStackView.addArrangedSubview(rankStaticLabel)
        
        overviewBackgroundView.addSubview(foodRankStackView)
    }
    
    private func setDataOnUIElements() {
        guard let data = data else {
            return
        }
        if let imgURL = data.foodImgURL {
            mainImageView.loadImageUsingCache(withUrl: imgURL)
        }
        
        titleLabel.text = data.foodName
        priceLabel.text = "₾\(data.price.format())"
        cuisineLabel.text = "🍽 Cuisine - " + data.cuisine
        rankLabel.text = data.foodRank
        aboutDishTextView.text = data.about
    }
    
    private func addSubviewInBackgroundAndInOverview() {
        view.addSubview(mainImageView)
        view.addSubview(overviewBackgroundView)
        
        cheapDeliveryView.addSubview(cheapDeliveryLabel)
        starBackView.addSubview(starImageView)
        configureRankStackView()
        
        overviewBackgroundView.addSubview(titleLabel)
        overviewBackgroundView.addSubview(priceLabel)
        overviewBackgroundView.addSubview(cuisineLabel)
        overviewBackgroundView.addSubview(cheapDeliveryView)
        overviewBackgroundView.addSubview(starBackView)
        overviewBackgroundView.addSubview(foodRankStackView)
        overviewBackgroundView.addSubview(detailsStaticLabel)
        overviewBackgroundView.addSubview(bottomLineOfDetails)
        overviewBackgroundView.addSubview(aboutDishTextView)
        
    }
    
    private func configureUIElementsConstraints() {
        
        addSubviewInBackgroundAndInOverview()
        
        NSLayoutConstraint.activate([
            mainImageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3.5),
            mainImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            overviewBackgroundView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -50),
            overviewBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overviewBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overviewBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: overviewBackgroundView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: overviewBackgroundView.leadingAnchor, constant: 25),
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            
            priceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: overviewBackgroundView.trailingAnchor, constant: -25),
            priceLabel.heightAnchor.constraint(equalToConstant: 20),
            
            cuisineLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            cuisineLabel.leadingAnchor.constraint(equalTo: overviewBackgroundView.leadingAnchor, constant: 25),
            cuisineLabel.heightAnchor.constraint(equalToConstant: 20),
            cuisineLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 1.3),
            
            cheapDeliveryView.topAnchor.constraint(equalTo: cuisineLabel.bottomAnchor, constant: 20),
            cheapDeliveryView.leadingAnchor.constraint(equalTo: overviewBackgroundView.leadingAnchor, constant: 25),
            cheapDeliveryView.heightAnchor.constraint(equalToConstant: 24),
            cheapDeliveryView.widthAnchor.constraint(equalToConstant: 110),
            
            cheapDeliveryLabel.centerXAnchor.constraint(equalTo: cheapDeliveryView.centerXAnchor),
            cheapDeliveryLabel.centerYAnchor.constraint(equalTo: cheapDeliveryView.centerYAnchor),
            cheapDeliveryLabel.widthAnchor.constraint(equalToConstant: 90),
            cheapDeliveryLabel.heightAnchor.constraint(equalToConstant: 18),
            
            starBackView.topAnchor.constraint(equalTo: cheapDeliveryView.bottomAnchor, constant: 20),
            starBackView.leadingAnchor.constraint(equalTo: overviewBackgroundView.leadingAnchor, constant: 25),
            starBackView.widthAnchor.constraint(equalToConstant: 40),
            starBackView.heightAnchor.constraint(equalToConstant: 40),
            
            starImageView.centerXAnchor.constraint(equalTo: starBackView.centerXAnchor),
            starImageView.centerYAnchor.constraint(equalTo: starBackView.centerYAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 23),
            starImageView.heightAnchor.constraint(equalToConstant: 20),
            
            foodRankStackView.leadingAnchor.constraint(equalTo: starBackView.trailingAnchor, constant: 5),
            foodRankStackView.centerYAnchor.constraint(equalTo: starBackView.centerYAnchor),
            foodRankStackView.heightAnchor.constraint(equalToConstant: 35),
            foodRankStackView.widthAnchor.constraint(equalToConstant: 100),
            
            
            aboutDishTextView.leadingAnchor.constraint(equalTo: overviewBackgroundView.leadingAnchor, constant: 20),
            aboutDishTextView.trailingAnchor.constraint(equalTo: overviewBackgroundView.trailingAnchor, constant: -25),
            aboutDishTextView.bottomAnchor.constraint(equalTo: overviewBackgroundView.bottomAnchor, constant: 15),
            aboutDishTextView.heightAnchor.constraint(equalToConstant: view.frame.height / 4),
            
            bottomLineOfDetails.leadingAnchor.constraint(equalTo: overviewBackgroundView.leadingAnchor, constant: 27),
            bottomLineOfDetails.bottomAnchor.constraint(equalTo: aboutDishTextView.topAnchor, constant: -5),
            bottomLineOfDetails.heightAnchor.constraint(equalToConstant: 2),
            bottomLineOfDetails.widthAnchor.constraint(equalToConstant: 75),
            
            detailsStaticLabel.leadingAnchor.constraint(equalTo: overviewBackgroundView.leadingAnchor, constant: 27),
            detailsStaticLabel.bottomAnchor.constraint(equalTo: bottomLineOfDetails.bottomAnchor, constant: -5),
            
        ])
    }
}




#if canImport(swiftUI) && DEBUG
import SwiftUI
struct PreviewMovieDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            DishDetailsVC()
        }.previewDevice("iPhone 12").previewInterfaceOrientation(.portrait)
    }
}



struct DishDetailsVCPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewControllerBuilder: () -> UIViewController

    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
#endif

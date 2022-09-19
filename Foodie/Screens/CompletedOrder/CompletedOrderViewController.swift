//
//  CompletedOrderViewController.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 25.08.22.
//

import UIKit

final class CompletedOrderViewController: UIViewController {
    
    // MARK: - Variables
    var orderPrice: String!
    var deliveryPrice: String!
    var summaryPrice: String!
    
    
    // MARK: - UIComponents By Programmatically
    var orderPriceLabel = UILabel()
    var deliveryPriceLabel = UILabel()
    var summaryPriceLabel = UILabel()
    
    private let logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = CustomImages.logo
        
        return imgView
    }()
    
    private let orderCompletedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    
    private let orderPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let deliveryPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let summaryPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let priceListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    
    private let continueShoppingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.backgroundColor = CustomColors.specialOrangeColor
        button.titleLabel?.textColor = .white
        button.setTitle("Continue Shopping", for: .normal)
        
        return button
    }()
    
    private let trackOrderShoppingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.backgroundColor = CustomColors.darkYellow
        button.titleLabel?.textColor = .black
        button.setTitle("Track Order", for: .normal)
        
        
        return button
    }()
    
    private let shoppingAndTrackingButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: CustomImages.backgroundImage!)
        createLabels()
        configureWholeUI()
        setPricesOnLabels()
        trackOrderShoppingButton.addTarget(self, action: #selector(moveToTrackOrderVc), for: .touchUpInside)
        continueShoppingButton.addTarget(self, action: #selector(moveToContinueShoppingButtonAction), for: .touchUpInside)
    }
    
    // MARK: - Funcs
    @objc func moveToTrackOrderVc() {
        print("pressed move to track order button")
        let vc = TrackOrderViewController()
       
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToContinueShoppingButtonAction() {
        let nav = UINavigationController()
        let coordinator = MainViewCoordinator(navigationController: nav)
        coordinator.start()
        
        self.view.window?.rootViewController = nav
        self.view.window?.makeKeyAndVisible()
    }
    
    private func generatePricesLabels(fontSize: CGFloat, isBold: Bool, textColor: UIColor?, text: String?, textAlignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.textAlignment = textAlignment
        if let text = text {
            label.text = text
        }
        if isBold {
            label.font = .boldSystemFont(ofSize: fontSize)
            
        } else {
            label.font = .systemFont(ofSize: fontSize)
        }
         
        return label
    }
    
    private func createLabels() {
        let orderCompletedLabel: UILabel = generatePricesLabels(fontSize: 24, isBold: true, textColor: CustomColors.specialOrangeColor, text: "Order completed!", textAlignment: .center)
        let orderNumberLabel: UILabel = generatePricesLabels(fontSize: 15, isBold: false, textColor: .systemGray2, text: "Order number: #\(Int.random(in: 100_000 ... 999_999))", textAlignment: .center)
        
        let orderStaticLabel: UILabel = generatePricesLabels(fontSize: 16, isBold: false, textColor: .black, text: "Order", textAlignment: .left)
        let deliveryStaticLabel: UILabel = generatePricesLabels(fontSize: 16, isBold: false, textColor: .black, text: "Delivery", textAlignment: .left)
        let summaryStaticLabel: UILabel = generatePricesLabels(fontSize: 19, isBold: true, textColor: .black, text: "Summary", textAlignment: .left)
        
        orderPriceLabel = generatePricesLabels(fontSize: 16, isBold: false, textColor: .black, text: "987.2 ლ", textAlignment: .right)
        deliveryPriceLabel = generatePricesLabels(fontSize: 16, isBold: false, textColor: .black, text: nil, textAlignment: .right)
        summaryPriceLabel = generatePricesLabels(fontSize: 19, isBold: true, textColor: .black, text: nil, textAlignment: .right)
         
        orderCompletedStackView.addArrangedSubview(orderCompletedLabel)
        orderCompletedStackView.addArrangedSubview(orderNumberLabel)
        
        orderPriceStackView.addArrangedSubview(orderStaticLabel)
        orderPriceStackView.addArrangedSubview(orderPriceLabel)
        
        deliveryPriceStackView.addArrangedSubview(deliveryStaticLabel)
        deliveryPriceStackView.addArrangedSubview(deliveryPriceLabel)
        
        summaryPriceStackView.addArrangedSubview(summaryStaticLabel)
        summaryPriceStackView.addArrangedSubview(summaryPriceLabel)
    }
    
    private func configureWholeUI() {
        configurMainLogo()
        configureCompletedOrderLabelsStackView()
        configureButtonsStackView()
        configurePriceListStackView()
    }
    
    private func setPricesOnLabels() {
        orderPriceLabel.text = orderPrice
        deliveryPriceLabel.text = deliveryPrice
        summaryPriceLabel.text = summaryPrice
    }
    
    func configurMainLogo() {
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 170),
            logoImageView.heightAnchor.constraint(equalToConstant: 152),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureCompletedOrderLabelsStackView() {
        view.addSubview(orderCompletedStackView)
        
        NSLayoutConstraint.activate([
            orderCompletedStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            orderCompletedStackView.widthAnchor.constraint(equalToConstant: 200),
            orderCompletedStackView.heightAnchor.constraint(equalToConstant: 60),
            orderCompletedStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    func configurePriceListStackView() {
        priceListStackView.addArrangedSubview(orderPriceStackView)
        priceListStackView.addArrangedSubview(deliveryPriceStackView)
        priceListStackView.addArrangedSubview(summaryPriceStackView)
        view.addSubview(priceListStackView)
        
        NSLayoutConstraint.activate([
            priceListStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            priceListStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            priceListStackView.bottomAnchor.constraint(equalTo: shoppingAndTrackingButtonsStackView.topAnchor, constant: -50),
            priceListStackView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    
    func configureButtonsStackView() {
        shoppingAndTrackingButtonsStackView.addArrangedSubview(continueShoppingButton)
        shoppingAndTrackingButtonsStackView.addArrangedSubview(trackOrderShoppingButton)
        view.addSubview(shoppingAndTrackingButtonsStackView)
        
        NSLayoutConstraint.activate([
            shoppingAndTrackingButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            shoppingAndTrackingButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            shoppingAndTrackingButtonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            shoppingAndTrackingButtonsStackView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }

}

// MARK: - Swift UI Live Builder (Canvas)
#if canImport(swiftUI) && DEBUG
import SwiftUI
struct PreviewViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            CompletedOrderViewController()
        }.previewDevice("iPhone 12").previewInterfaceOrientation(.portrait)
    }
}

struct ViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
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

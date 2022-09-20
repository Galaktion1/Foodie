//
//  OnBoardingViewController.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 09.09.22.
//

import UIKit

class OnboardingVC: UIViewController {
    
    //MARK: - Variables
    private var counter = 0
    private let animationArray = [OnboardingCellInfo(image: "lottieBurger", largeText: "Welcome to Foodie", smallText: "Allow users to chek real-time menu \nin restaurant you want."),
                                  OnboardingCellInfo(image: "lottieCourier", largeText: "Fast delivery", smallText: "Order food and get delivery in\n the fastest time in the town."),
                                  OnboardingCellInfo(image: "lottiePayment", largeText: "Easy payment", smallText: "No matter if you order \nonline or cash.")]
    
    
    //MARK: - UIComponents
    private let backgroundImageView = UIImageView(image: CustomImages.backgroundImage)
    
    private let onboardingPages: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.isUserInteractionEnabled = true
        collection.allowsSelection = false
        collection.isPagingEnabled = true
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        
        return collection
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.contentMode = .left
        button.backgroundColor = .clear
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(CustomColors.specialOrangeColor, for: .normal)
        
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.contentMode = .right
        button.backgroundColor = .clear
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(CustomColors.specialOrangeColor, for: .normal)
        
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = CustomColors.specialOrangeColor
        pageControl.pageIndicatorTintColor = .gray
        
        return pageControl
    }()
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.frame
        
        onboardingPages.dataSource = self
        onboardingPages.delegate = self
        
        backButton.addTarget(self, action: #selector(goToBackItem), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(gotoNextItem), for: .touchUpInside)
        
        onboardingPages.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.identifier)
        
        configiureUIElements()
    }
    
    // MARK: - Funcs
    private func configiureUIElements() {
        
        view.addSubview(onboardingPages)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        
        onboardingPages.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        onboardingPages.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        onboardingPages.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        onboardingPages.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*3/4 + 50).isActive = true
        
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -38),
            pageControl.widthAnchor.constraint(equalToConstant: 150),
            pageControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func goToSignInVC() {
        let vc = SignInConfigurator.configure()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func goToBackItem() {
        if counter > 0 {
            onboardingPages.isPagingEnabled = false
            counter -= 1
            pageControl.currentPage = counter
            
            onboardingPages.scrollToItem(
                at: IndexPath(item: counter, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            onboardingPages.isPagingEnabled = true
        }
    }
    
    @objc func gotoNextItem() {
        if counter < animationArray.count-1 {
            onboardingPages.isPagingEnabled = false
            counter += 1
            pageControl.currentPage = counter
            
            onboardingPages.scrollToItem(
                at: IndexPath(item: counter, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            onboardingPages.isPagingEnabled = true
        } else {
            goToSignInVC()
        }
    }
}



extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: onboardingPages.frame.width, height: onboardingPages.frame.height)
        return size
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        animationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.identifier, for: indexPath) as! OnboardingCell
        cell.makeCell(info: animationArray[indexPath.row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl.currentPage = Int(roundedIndex)
        counter = Int(roundedIndex)
    }
}


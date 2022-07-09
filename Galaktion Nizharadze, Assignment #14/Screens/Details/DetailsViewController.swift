//
//  DetailsViewController.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 09.07.22.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var logOutButtonOutlet: UIButton!
    @IBOutlet weak var topMailLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var whiteView: UIView!
    
    var userName: String!
    var email: String!
    private let bottomSheetHeight: CGFloat = 250
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "img_background")!)
        whiteView.backgroundColor = .white.withAlphaComponent(0)
        
        confUI()
    }
    
    let myView = Bundle.main.loadNibNamed("BottomSheetView", owner: nil, options: nil)![0] as? BottomSheetView
    
    @IBAction func logOutButton(_ sender: UIButton) {
        
        myView?.frame = CGRect(x: 15, y: UIScreen.main.bounds.height - bottomSheetHeight - 10, width: UIScreen.main.bounds.width - 30, height: bottomSheetHeight)
        myView?.delegate = self
        
        view.addSubview(myView!)
    }
    
    
    private func confUI() {
        guard let userName = userName, let email = email else {
            return
        }
        
        mailLabel.text = email
        topMailLabel.text = email
        userNameLabel.text = userName
        welcomeLabel.text = "Hello \(userName.capitalized), Welcome Back! "
        welcomeLabel.textColor = UIColor(named: "specialOrange")!
        
        logOutButtonOutlet.backgroundColor = UIColor(named: "specialOrange")!
        logOutButtonOutlet.layer.cornerRadius = 29.5
    }
}


extension DetailsViewController: BottomSheetViewDelegate {
    func dismiss() {
        myView?.removeFromSuperview()
    }
    
    func logOut() {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "NavigationViewController")
        
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
}

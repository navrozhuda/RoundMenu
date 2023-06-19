//
//  ViewController.swift
//  DemoRoundMenu
//
//  Created by Navroz Huda on 10/06/23.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet var roundView:RoundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundView.menuList = [MenuItem(name:"dashBoard", imageName:"police"),
                              MenuItem(name:"profile", imageName:"police"),
                              MenuItem(name:"contactus", imageName:"police"),
                              MenuItem(name:"user", imageName: "police"),
                              MenuItem(name:"terms and conditions", imageName: "police"),
                              MenuItem(name:"signout", imageName: "police")]
        roundView.delegate = self
        roundView.setupUI()
       
    }
}
extension ViewController: RoundMenuDelegate {
    func menuClicked(menuItem: MenuItem) {
        print(menuItem.name)
    }
    
}

//
//  AreaDetectionViewController.swift
//  Area Detection
//
//  Created by 2018MAC04 on 04/09/2021.
//

import UIKit

class AreaDetectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView(){
        let topRightButton = UIButton()
        topRightButton.setImage(UIImage(named: "icn-setting"), for: .normal)
        
        let barButton = UIBarButtonItem(customView: topRightButton)
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
}


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
        topRightButton.addTarget(self, action: #selector(doBtnSetupGeoArea), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: topRightButton)
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    @objc func doBtnSetupGeoArea(){
        let vc = SetupGeoAreaViewController(nibName: "SetupGeoAreaViewController", bundle: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


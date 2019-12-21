//
//  MainMenuViewController.swift
//  RED-7
//
//  Created by Михаил Первеев on 05/10/2019.
//  Copyright © 2019 com.perveev.mike. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsButton.setTitle("Настройки", for: .normal)
        settingsButton.backgroundColor = .orange
        
        view.addSubview(settingsButton)
    }
    
    override func viewWillLayoutSubviews() {
        settingsButton.frame = CGRect(x: view.frame.width / 3, y: view.frame.height / 2 - 35, width: view.frame.width / 3, height: 70)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "OpenSettings", sender: self)
    }
}

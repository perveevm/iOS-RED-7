//
//  SettingsMenuViewController.swift
//  RED-7
//
//  Created by Михаил Первеев on 05/10/2019.
//  Copyright © 2019 com.perveev.mike. All rights reserved.
//

import UIKit

class SettingsMenuViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var soundEffectsLabel: UILabel!
    @IBOutlet weak var soundEffectsSwitch: UISwitch!
    @IBOutlet weak var hintsLabel: UILabel!
    @IBOutlet weak var hintsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.setTitle("Назад", for: .normal)
        backButton.backgroundColor = .orange
        backButton.layer.cornerRadius = 5
        backButton.layer.borderWidth = 0.5
        backButton.layer.borderColor = UIColor.white.cgColor
        
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        
        musicSwitch.isOn = true
        musicLabel.text = "Музыка"
        
        soundEffectsSwitch.isOn = true
        soundEffectsLabel.text = "Звуковые эффекты"
        
        hintsSwitch.isOn = true
        hintsLabel.text = "Подсказки"

        view.addSubview(backButton)
        view.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewWillLayoutSubviews() {
        musicLabel.frame = CGRect(x: view.frame.width / 4, y: 20, width: view.frame.width / 4, height: 30)
        musicSwitch.frame = CGRect(x: 2.5 * view.frame.width / 4, y: 20, width: view.frame.width / 4, height: 30)
        
        soundEffectsLabel.frame = CGRect(x: view.frame.width / 4, y: 60, width: view.frame.width / 4, height: 30)
        soundEffectsSwitch.frame = CGRect(x: 2.5 * view.frame.width / 4, y: 60, width: view.frame.width / 4, height: 30)
        
        hintsLabel.frame = CGRect(x: view.frame.width / 4, y: 100, width: view.frame.width / 4, height: 30)
        hintsSwitch.frame = CGRect(x: 2.5 * view.frame.width / 4, y: 100, width: view.frame.width / 4, height: 30)
        
        backButton.frame = CGRect(x: view.frame.width / 3, y: view.frame.height - 100 - 35, width: view.frame.width / 3, height: 45)
        
        backgroundImage.frame = view.bounds
        backgroundImage.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
    }
    
    @IBAction func backButtonPassed(_ sender: Any) {
        performSegue(withIdentifier: "ShowMainMenu", sender: self)
    }
}

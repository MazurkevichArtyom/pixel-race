//
//  ViewController.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 08.02.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addTestButton()
    }

    @IBAction func onStartButton(_ sender: Any) {
        let gameVC = GameViewController()
        navigationController?.pushViewController(gameVC, animated: false)
    }
    
    private func addTestButton() {
        let button = UIButton(frame: CGRect(x: 40, y: view.bounds.height - 100, width: 70, height: 50))
        button.setTitle("Settings", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(onTestButton), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func onTestButton() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: false)
    }
    
}


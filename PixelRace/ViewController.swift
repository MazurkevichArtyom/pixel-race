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
        
        AnalyticsManager.shared.logScreenEvent(screen: .main, className: String(describing: self))
    }
    
    @IBAction func onStartButton(_ sender: Any) {
        let gameVC = GameViewController()
        navigationController?.pushViewController(gameVC, animated: false)
    }
    
    @IBAction func onSettingsButton(_ sender: Any) {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: false)
    }
    
    @IBAction func onLeaderboardButton(_ sender: Any) {
        let leaderboardVC = LeaderboardViewController()
        navigationController?.pushViewController(leaderboardVC, animated: false)
    }
}


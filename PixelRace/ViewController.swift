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
    }

    @IBAction func onStartButton(_ sender: Any) {
        let gameVC = GameViewController()
        navigationController?.pushViewController(gameVC, animated: false)
    }
    
}

//
//  SettingsViewController.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 03.04.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func loadView() {
        let customView = UIView(frame: UIScreen.main.bounds)
        customView.backgroundColor = UIColor(hex: 0x2E2E2E)
        view = customView
    }
    
    let rectangleImage = UIImageView()
    let hardContainer = UIView()
    let easyContainer = UIView()
    let normalContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let bar = CustomNavigationBar(navigationBarOptions: [.back, .save])
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setTitle(title: "SETTINGS")
        view.addSubview(bar)
        
        bar.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        bar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bar.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        
        let selectCarLabel = UILabel()
        selectCarLabel.textColor = .white
        selectCarLabel.translatesAutoresizingMaskIntoConstraints = false
        selectCarLabel.font = UIFont(name: "PublicPixel", size: 16)
        selectCarLabel.textAlignment = .left
        selectCarLabel.text = "SELECT CAR"
        view.addSubview(selectCarLabel)
        selectCarLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        selectCarLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        selectCarLabel.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: 80).isActive = true
        
        let difficultyLabel = UILabel()
        difficultyLabel.textColor = .white
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyLabel.font = UIFont(name: "PublicPixel", size: 16)
        difficultyLabel.textAlignment = .left
        difficultyLabel.text = "DIFFICULTY"
        view.addSubview(difficultyLabel)
        difficultyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        difficultyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        difficultyLabel.topAnchor.constraint(equalTo: selectCarLabel.bottomAnchor, constant: 60).isActive = true
        
        let difficultiesContainer = UIView()
        difficultiesContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(difficultiesContainer)
        difficultiesContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        difficultiesContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        difficultiesContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        difficultiesContainer.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 40).isActive = true
        
        easyContainer.translatesAutoresizingMaskIntoConstraints = false
        difficultiesContainer.addSubview(easyContainer)
        easyContainer.heightAnchor.constraint(equalTo: difficultiesContainer.heightAnchor, multiplier: 1.0).isActive = true
        easyContainer.widthAnchor.constraint(equalTo: difficultiesContainer.heightAnchor, multiplier: 1.1).isActive = true
        easyContainer.centerYAnchor.constraint(equalTo: difficultiesContainer.centerYAnchor).isActive = true
        easyContainer.leadingAnchor.constraint(equalTo: difficultiesContainer.leadingAnchor).isActive = true
        
        let imageSpacing = 10.0
        
        let easyImage = UIImageView()
        easyImage.translatesAutoresizingMaskIntoConstraints = false
        easyImage.contentMode = .scaleAspectFit
        easyImage.image = UIImage(named: "settings_easy")
        easyContainer.addSubview(easyImage)
        easyImage.leadingAnchor.constraint(equalTo: easyContainer.leadingAnchor, constant: imageSpacing).isActive = true
        easyImage.topAnchor.constraint(equalTo: easyContainer.topAnchor, constant: imageSpacing).isActive = true
        easyImage.trailingAnchor.constraint(equalTo: easyContainer.trailingAnchor, constant: -imageSpacing).isActive = true
        easyImage.bottomAnchor.constraint(equalTo: easyContainer.bottomAnchor, constant: -imageSpacing).isActive = true
        
        rectangleImage.translatesAutoresizingMaskIntoConstraints = false
        rectangleImage.contentMode = .scaleAspectFit
        rectangleImage.image = UIImage(named: "select_rectangle")
        difficultiesContainer.addSubview(rectangleImage)
        rectangleImage.heightAnchor.constraint(equalTo: easyContainer.heightAnchor).isActive = true
        rectangleImage.widthAnchor.constraint(equalTo: easyContainer.widthAnchor).isActive = true
        rectangleImage.centerYAnchor.constraint(equalTo: difficultiesContainer.centerYAnchor).isActive = true
        rectangleImage.leadingAnchor.constraint(equalTo: easyContainer.leadingAnchor).isActive = true

        normalContainer.translatesAutoresizingMaskIntoConstraints = false
        difficultiesContainer.addSubview(normalContainer)
        normalContainer.heightAnchor.constraint(equalTo: difficultiesContainer.heightAnchor, multiplier: 1.0).isActive = true
        normalContainer.widthAnchor.constraint(equalTo: difficultiesContainer.heightAnchor, multiplier: 1.1).isActive = true
        normalContainer.centerXAnchor.constraint(equalTo: difficultiesContainer.centerXAnchor).isActive = true
        normalContainer.centerYAnchor.constraint(equalTo: difficultiesContainer.centerYAnchor).isActive = true
        
        let normalImage = UIImageView()
        normalImage.translatesAutoresizingMaskIntoConstraints = false
        normalImage.contentMode = .scaleAspectFit
        normalImage.image = UIImage(named: "settings_normal")
        normalContainer.addSubview(normalImage)
        normalImage.leadingAnchor.constraint(equalTo: normalContainer.leadingAnchor, constant: imageSpacing).isActive = true
        normalImage.topAnchor.constraint(equalTo: normalContainer.topAnchor, constant: imageSpacing).isActive = true
        normalImage.trailingAnchor.constraint(equalTo: normalContainer.trailingAnchor, constant: -imageSpacing).isActive = true
        normalImage.bottomAnchor.constraint(equalTo: normalContainer.bottomAnchor, constant: -imageSpacing).isActive = true
        
        hardContainer.translatesAutoresizingMaskIntoConstraints = false
        difficultiesContainer.addSubview(hardContainer)
        hardContainer.heightAnchor.constraint(equalTo: difficultiesContainer.heightAnchor, multiplier: 1.0).isActive = true
        hardContainer.widthAnchor.constraint(equalTo: difficultiesContainer.heightAnchor, multiplier: 1.1).isActive = true
        hardContainer.centerYAnchor.constraint(equalTo: difficultiesContainer.centerYAnchor).isActive = true
        hardContainer.trailingAnchor.constraint(equalTo: difficultiesContainer.trailingAnchor).isActive = true
        
        let hardImage = UIImageView()
        hardImage.translatesAutoresizingMaskIntoConstraints = false
        hardImage.contentMode = .scaleAspectFit
        hardImage.image = UIImage(named: "settings_hard")
        hardContainer.addSubview(hardImage)
        hardImage.leadingAnchor.constraint(equalTo: hardContainer.leadingAnchor, constant: imageSpacing).isActive = true
        hardImage.topAnchor.constraint(equalTo: hardContainer.topAnchor, constant: imageSpacing).isActive = true
        hardImage.trailingAnchor.constraint(equalTo: hardContainer.trailingAnchor, constant: -imageSpacing).isActive = true
        hardImage.bottomAnchor.constraint(equalTo: hardContainer.bottomAnchor, constant: -imageSpacing).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapHard));
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(onTapHard));
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(onTapHard));

        easyContainer.addGestureRecognizer(tap)
        normalContainer.addGestureRecognizer(tap2)
        hardContainer.addGestureRecognizer(tap3)
        // Do any additional setup after loading the view.
    }
    
    @objc private func onTapHard(gestureRecognizer: UITapGestureRecognizer) {
        guard let selectedView = gestureRecognizer.view else {
            return
        }
        
        if (rectangleImage.transform.tx != selectedView.frame.origin.x) {
            UIView.animate(withDuration: 0.3) {
                self.rectangleImage.transform = CGAffineTransform(translationX: selectedView.frame.origin.x, y: 0)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

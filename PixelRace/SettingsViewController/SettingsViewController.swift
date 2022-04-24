//
//  SettingsViewController.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 03.04.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let selectCarContainer = UIView()
    let rectangleImage = UIImageView()
    let hardContainer = UIView()
    let easyContainer = UIView()
    let normalContainer = UIView()
    let carImage = UIImageView()
    let nextCarButton = UIButton()
    let previousCarButton = UIButton()
    
    var settings = Settings()
    
    var customNavigationBar: CustomNavigationBar?
    
    override func loadView() {
        let customView = UIView(frame: UIScreen.main.bounds)
        customView.backgroundColor = K.Colors.mainBackgroundColor
        view = customView
        setupNavigationBar()
        setupSelectCarView()
        setupDifficultyView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tryToGetSettings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applySettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func onDifficultySelected(gestureRecognizer: UITapGestureRecognizer) {
        guard let selectedView = gestureRecognizer.view else {
            return
        }
        
        if selectedView == easyContainer {
            settings.difficulty = .easy
        } else if selectedView == normalContainer {
            settings.difficulty = .normal
        } else if selectedView == hardContainer {
            settings.difficulty = .hard
        }
        
        if (rectangleImage.transform.tx != selectedView.frame.origin.x) {
            UIView.animate(withDuration: 0.3) {
                self.rectangleImage.transform = CGAffineTransform(translationX: selectedView.frame.origin.x, y: 0)
            }
        }
    }
    
    @objc private func onSelectCar(sender: UIButton) {
        if abs(sender.tag) == 1 {
            let newSkinnId = (settings.skinId - 1 + sender.tag + 3) % 3 + 1
            settings.skinId = newSkinnId
            carImage.image = UIImage(named: ResourcesHelper.playersCarSkin(skinId: settings.skinId))
        }
    }
    
    private func setupNavigationBar() {
        let leftItem = CustomNavigationBarItem(imageName: "button_back", itemAction: {
            self.navigationController?.popViewController(animated: false)
        })
        let rightItem = CustomNavigationBarItem(imageName: "button_save", itemAction: tryToSaveSettings)
        let bar = CustomNavigationBar(leftItem: leftItem, rightItem: rightItem)
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setTitle(title: "SETTINGS")
        view.addSubview(bar)
        
        bar.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        bar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bar.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        
        customNavigationBar = bar
    }
    
    private func setupSelectCarView() {
        guard let customNavigationBar = customNavigationBar else {
            return
        }
        
        let selectCarLabel = UILabel()
        selectCarLabel.textColor = .white
        selectCarLabel.translatesAutoresizingMaskIntoConstraints = false
        selectCarLabel.font = UIFont(name: "PublicPixel", size: 16)
        selectCarLabel.textAlignment = .left
        selectCarLabel.text = "SELECT CAR"
        view.addSubview(selectCarLabel)
        selectCarLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        selectCarLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        selectCarLabel.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 80).isActive = true
        
        selectCarContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectCarContainer)
        selectCarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        selectCarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        selectCarContainer.topAnchor.constraint(equalTo: selectCarLabel.bottomAnchor, constant: 40).isActive = true
        selectCarContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15, constant: 1.0).isActive = true
        
        let carContainer = UIView()
        carContainer.translatesAutoresizingMaskIntoConstraints = false
        carContainer.clipsToBounds = true
        selectCarContainer.addSubview(carContainer)
        carContainer.topAnchor.constraint(equalTo: selectCarContainer.topAnchor).isActive = true
        carContainer.bottomAnchor.constraint(equalTo: selectCarContainer.bottomAnchor).isActive = true
        carContainer.widthAnchor.constraint(equalTo: selectCarContainer.widthAnchor, multiplier: 0.3, constant: 1.0).isActive = true
        carContainer.centerXAnchor.constraint(equalTo: selectCarContainer.centerXAnchor).isActive = true
        
        carImage.contentMode = .scaleAspectFit
        carImage.translatesAutoresizingMaskIntoConstraints = false
        carContainer.addSubview(carImage);
        carImage.leadingAnchor.constraint(equalTo: carContainer.leadingAnchor).isActive = true
        carImage.trailingAnchor.constraint(equalTo: carContainer.trailingAnchor).isActive = true
        carImage.topAnchor.constraint(equalTo: carContainer.topAnchor).isActive = true
        carImage.bottomAnchor.constraint(equalTo: carContainer.bottomAnchor).isActive = true
        
        previousCarButton.translatesAutoresizingMaskIntoConstraints = false
        previousCarButton.tag = -1
        previousCarButton.setImage(UIImage(named: "button_arrow"), for: .normal)
        previousCarButton.addTarget(self, action: #selector(onSelectCar), for: .touchUpInside)
        selectCarContainer.addSubview(previousCarButton)
        previousCarButton.trailingAnchor.constraint(equalTo: carContainer.leadingAnchor, constant: -20).isActive = true
        previousCarButton.heightAnchor.constraint(equalTo: selectCarContainer.heightAnchor, multiplier: 0.4, constant: 1.0).isActive = true
        previousCarButton.widthAnchor.constraint(equalTo: previousCarButton.heightAnchor, multiplier: 0.7, constant: 1.0).isActive = true
        previousCarButton.centerYAnchor.constraint(equalTo: carContainer.centerYAnchor).isActive = true
        
        nextCarButton.translatesAutoresizingMaskIntoConstraints = false
        nextCarButton.tag = 1
        nextCarButton.setImage(UIImage(named: "button_arrow")?.withHorizontallyFlippedOrientation(), for: .normal)
        nextCarButton.addTarget(self, action: #selector(onSelectCar), for: .touchUpInside)
        selectCarContainer.addSubview(nextCarButton)
        nextCarButton.leadingAnchor.constraint(equalTo: carContainer.trailingAnchor, constant: 20).isActive = true
        nextCarButton.heightAnchor.constraint(equalTo: selectCarContainer.heightAnchor, multiplier: 0.4, constant: 1.0).isActive = true
        nextCarButton.widthAnchor.constraint(equalTo: nextCarButton.heightAnchor, multiplier: 0.7, constant: 1.0).isActive = true
        nextCarButton.centerYAnchor.constraint(equalTo: carContainer.centerYAnchor).isActive = true
    }
    
    private func setupDifficultyView() {
        let difficultyLabel = UILabel()
        difficultyLabel.textColor = .white
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyLabel.font = UIFont(name: "PublicPixel", size: 16)
        difficultyLabel.textAlignment = .left
        difficultyLabel.text = "DIFFICULTY"
        view.addSubview(difficultyLabel)
        difficultyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        difficultyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        difficultyLabel.topAnchor.constraint(equalTo: selectCarContainer.bottomAnchor, constant: 60).isActive = true
        
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
        
        let easyTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDifficultySelected));
        let normalTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDifficultySelected));
        let hardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDifficultySelected));
        
        easyContainer.addGestureRecognizer(easyTapGestureRecognizer)
        normalContainer.addGestureRecognizer(normalTapGestureRecognizer)
        hardContainer.addGestureRecognizer(hardTapGestureRecognizer)
    }
    
    private func tryToSaveSettings() {
        let data = try? JSONEncoder().encode(settings)
        UserDefaults.standard.set(data, forKey: K.Strings.settings)
        
        navigationController?.popViewController(animated: false)
    }
    
    private func tryToGetSettings() {
        if let savedData = UserDefaults.standard.value(forKey: K.Strings.settings) as? Data {
            if let savedSettings = try? JSONDecoder().decode(Settings.self, from: savedData) {
                settings = savedSettings
            }
        }
    }
    
    private func applySettings() {
        carImage.image = UIImage(named: ResourcesHelper.playersCarSkin(skinId: settings.skinId))
        
        var selectedView = easyContainer
        
        switch settings.difficulty {
        case .easy:
            selectedView = easyContainer
        case .normal:
            selectedView = normalContainer
        case .hard:
            selectedView = hardContainer
        }
        
        rectangleImage.transform = CGAffineTransform(translationX: selectedView.frame.origin.x, y: 0)
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

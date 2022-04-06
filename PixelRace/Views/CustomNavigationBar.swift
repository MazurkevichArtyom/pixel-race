//
//  CustomNavigationBar.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 03.04.2022.
//

import UIKit

enum NavigationBarMode {
    case none
    case back
    case save
}

class CustomNavigationBar: UIView {
    
    private let options: [NavigationBarMode]
    private var titleLabel: UILabel?
    
    init(navigationBarOptions: [NavigationBarMode]) {
        options = navigationBarOptions
        super.init(frame: .zero)
        setupNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitle(title: String) {
        if let titleLabel = titleLabel {
            titleLabel.text = title
        }
    }
    
    private func setupNavigationBar() {
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "button_back"), for: .normal)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftButton)
        leftButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        leftButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        leftButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        leftButton.isHidden = !options.contains(.back)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "button_save"), for: .normal)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightButton)
        rightButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        rightButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        rightButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        rightButton.isHidden = !options.contains(.save)
        
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PublicPixel", size: 18)
        label.textAlignment = .center
        addSubview(label)
        label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        label.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        titleLabel = label
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

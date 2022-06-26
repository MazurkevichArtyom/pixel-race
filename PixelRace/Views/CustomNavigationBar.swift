//
//  CustomNavigationBar.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 03.04.2022.
//

import UIKit

class CustomNavigationBar: UIView {
    
    private var titleLabel: UILabel?
    private var leftItem: CustomNavigationBarItem?
    private var rightItem: CustomNavigationBarItem?
    
    init(leftItem: CustomNavigationBarItem?, rightItem: CustomNavigationBarItem?) {
        self.leftItem = leftItem
        self.rightItem = rightItem
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
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftButton)
        leftButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        leftButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        leftButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        if let leftItem = leftItem {
            leftButton.setImage(UIImage(named: leftItem.imageName), for: .normal)
            leftButton.addTarget(self, action: #selector(onLeftButtonTapped), for: .touchUpInside)
        } else {
            leftButton.isHidden = true
        }
        
        let rightButton = UIButton()
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightButton)
        rightButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        rightButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        rightButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        if let rightItem = rightItem {
            rightButton.setImage(UIImage(named: rightItem.imageName), for: .normal)
            rightButton.addTarget(self, action: #selector(onRightButtonTapped), for: .touchUpInside)
        } else {
            rightButton.isHidden = true
        }
        
        let label = UILabel()
        label.textColor = Resources.Colors.mainTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PublicPixel", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 2
        addSubview(label)
        label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        label.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        titleLabel = label
    }
    
    @objc private func onLeftButtonTapped() {
        if let leftItem = leftItem {
            leftItem.itemAction()
        }
    }
    
    @objc private func onRightButtonTapped() {
        if let rightItem = rightItem {
            rightItem.itemAction()
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}

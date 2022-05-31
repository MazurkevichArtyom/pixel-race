//
//  LeaderboardTableViewCell.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 31.05.2022.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    let placeLabel: UILabel
    let carImage: UIImageView
    let scoreLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        placeLabel = UILabel()
        scoreLabel = UILabel()
        carImage = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupUI() {
        backgroundColor = Resources.Colors.mainBackgroundColor
        
        placeLabel.font = UIFont(name: "PublicPixel", size: 20)
        placeLabel.textColor = Resources.Colors.mainTextColor
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.textAlignment = .left
        contentView.addSubview(placeLabel)
        placeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true
        placeLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        placeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2).isActive = true
        placeLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        carImage.contentMode = .scaleAspectFit
        carImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(carImage)
        carImage.leadingAnchor.constraint(equalTo: placeLabel.trailingAnchor).isActive = true
        carImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2).isActive = true
        carImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        carImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        scoreLabel.font = UIFont(name: "PublicPixel", size: 20)
        scoreLabel.textColor = Resources.Colors.mainTextColor
        scoreLabel.textAlignment = .right
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scoreLabel)
        scoreLabel.leadingAnchor.constraint(equalTo: carImage.trailingAnchor, constant: 8).isActive = true
        scoreLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
}

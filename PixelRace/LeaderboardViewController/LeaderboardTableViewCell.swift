//
//  LeaderboardTableViewCell.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 31.05.2022.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    let placeLabel: UILabel
    let carImageView: UIImageView
    let dateLabel: UILabel
    let scoreLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        placeLabel = UILabel()
        scoreLabel = UILabel()
        dateLabel = UILabel()
        carImageView = UIImageView()
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
        
        placeLabel.font = UIFont(name: "PublicPixel", size: 12)
        placeLabel.textColor = Resources.Colors.mainTextColor
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.textAlignment = .left
        contentView.addSubview(placeLabel)
        placeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true
        placeLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        placeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1).isActive = true
        placeLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        carImageView.contentMode = .scaleAspectFit
        carImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(carImageView)
        carImageView.leadingAnchor.constraint(equalTo: placeLabel.trailingAnchor).isActive = true
        carImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2).isActive = true
        carImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        carImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        dateLabel.font = UIFont(name: "PublicPixel", size: 12)
        dateLabel.textColor = Resources.Colors.mainTextColor
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .center
        dateLabel.numberOfLines = 2
        contentView.addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: carImageView.trailingAnchor, constant: 8).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        scoreLabel.font = UIFont(name: "PublicPixel", size: 12)
        scoreLabel.textColor = Resources.Colors.mainTextColor
        scoreLabel.textAlignment = .right
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scoreLabel)
        scoreLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 8).isActive = true
        scoreLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
}

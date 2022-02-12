//
//  GameManager.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 10.02.2022.
//

import Foundation
import UIKit

class GameManager {
    static let shared = GameManager()
    
    private let rotationAngle: CGFloat = 15 * .pi / 180
    
    private let screenSize: CGSize
    private let sideWidth: CGFloat
    private let roadLaneWidth: CGFloat
    
    init() {
        screenSize = UIScreen.main.bounds.size
        sideWidth = screenSize.width * 0.15
        roadLaneWidth = (screenSize.width - 2 * sideWidth) / 3
    }
    
    func movePlayersCar(move: Move) {
        guard let car = SpawnerManager.shared.playersCar else {
            return
        }
        
        var destinationPoint = car.center
        var carRotationAngle = rotationAngle
        
        switch move {
        case .left:
            carRotationAngle = -rotationAngle
            destinationPoint = CGPoint(x: car.center.x - roadLaneWidth, y: car.center.y)
        case .right:
            destinationPoint = CGPoint(x: car.center.x + roadLaneWidth, y: car.center.y)
        }
        
        if destinationPoint.x > sideWidth && destinationPoint.x < screenSize.width - sideWidth {
            car.transform = CGAffineTransform(rotationAngle: carRotationAngle)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                car.center = destinationPoint
            } completion: { finish in
                car.transform = CGAffineTransform(rotationAngle: 0)
            }
        }

    }
}

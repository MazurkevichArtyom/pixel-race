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
    
    func movePlayersCar(move: Move) {
        guard let car = SpawnerManager.shared.playersCar else {
            return
        }
        
        guard let roadLaneSize = SpawnerManager.shared.roadLaneSize else {
            return
        }
        
        guard let sideAreaSize = SpawnerManager.shared.sideAreaSize else {
            return
        }
        
        guard let viewSize = SpawnerManager.shared.viewSize else {
            return
        }
        
        var destinationPoint = car.center
        var carRotationAngle = rotationAngle
        
        switch move {
        case .left:
            carRotationAngle = -rotationAngle
            destinationPoint = CGPoint(x: car.center.x - roadLaneSize.width, y: car.center.y)
        case .right:
            destinationPoint = CGPoint(x: car.center.x + roadLaneSize.width, y: car.center.y)
        }
        
        if destinationPoint.x > sideAreaSize.width && destinationPoint.x < viewSize.width - sideAreaSize.width {
            car.transform = CGAffineTransform(rotationAngle: carRotationAngle)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                car.center = destinationPoint
            } completion: { finish in
                car.transform = CGAffineTransform(rotationAngle: 0)
            }
        }

    }
}

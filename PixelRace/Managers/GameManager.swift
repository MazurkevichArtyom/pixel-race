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
    
    private let screenSize: CGSize
    private let roadLaneWidth: Double
    
    init() {
        screenSize = UIScreen.main.bounds.size
        let sideWidth = screenSize.width * 0.15
        roadLaneWidth = (screenSize.width - 2 * sideWidth) / 3
    }
    
    func movePlayersCar(move: Move) {
        guard let car = SpawnerManager.shared.playersCar else {
            return
        }
        
        var destinationPoint = car.center
        
        switch move {
        case .left:
            car.transform = CGAffineTransform(rotationAngle: -15 * .pi / 180)
            destinationPoint = CGPoint(x: car.center.x - roadLaneWidth, y: car.center.y)
        case .right:
            car.transform = CGAffineTransform(rotationAngle: 15 * .pi / 180)
            destinationPoint = CGPoint(x: car.center.x + roadLaneWidth, y: car.center.y)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            car.center = destinationPoint
        } completion: { finish in
            car.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
}

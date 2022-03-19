//
//  GameManager.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 10.02.2022.
//

import Foundation
import UIKit

class GameManager {
    private let viewController: UIViewController
    private let spawnerManager: SpawnerManager
    private let collisionManager: CollisionManager
    
    private let rotationAngle: CGFloat = 15 * .pi / 180
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        self.collisionManager = CollisionManager()
        self.spawnerManager = SpawnerManager(collisionManager: collisionManager, viewController: viewController)
    }
    
    func start() {
        spawnerManager.startGameObjectSpawning()
        collisionManager.startObserving(playersCar: spawnerManager.playersCar) {
            self.spawnerManager.invalidate()
            self.collisionManager.stopObserving()
            self.viewController.navigationController?.popViewController(animated: false)
        }
    }
    
    func stop() {
        
    }
    
    func setupGameScene() {
        spawnerManager.setupRacingLocation()
    }
    
    func movePlayersCar(move: Move) {
        guard let car = spawnerManager.playersCar,
              let roadLaneSize = spawnerManager.roadLaneSize,
              let sideAreaSize = spawnerManager.sideAreaSize,
              let viewSize = spawnerManager.viewSize else {
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

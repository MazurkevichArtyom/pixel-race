//
//  CollisionManager.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 11.02.2022.
//

import Foundation
import UIKit

class CollisionManager {
    static let shared = CollisionManager()
    
    private var collisionTimer: Timer?
    private var callBack: () -> Void = { }
    
    private var observables: [UIImageView] = [UIImageView]()
    
    func startObserving(collisionCallBack: @escaping () -> Void) {
        callBack = collisionCallBack
        collisionTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(checkCollisions), userInfo: nil, repeats: true)
    }
    
    func stopObserving() {
        collisionTimer?.invalidate()
        observables.removeAll()
    }
    
    func addObservableObject(observable: UIImageView) {
        observables.append(observable)
    }
    
    func removeObservableObject(observable: UIImageView) {
        if let index = observables.firstIndex(of: observable) {
            observables.remove(at: index)
        }
    }
    
    @objc private func checkCollisions() {
        guard let myCar = SpawnerManager.shared.playersCar else {
            return
        }
        
        guard let myCarFrame = myCar.layer.presentation()?.frame else {
            return
        }
        
        for observable in observables {
            if let oFrame = observable.layer.presentation()?.frame {
                if (myCarFrame.intersects(oFrame)) {
                    callBack()
                    break
                }
            }
        }
    }
}

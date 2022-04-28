//
//  ResourcesHelper.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 17.03.2022.
//

import Foundation

class ResourcesHelper {
    static func sideObjectImageName(object: SideObject) -> String {
        switch object {
        case .tree:
            return "tree"
        case .bush:
            return "bush"
        case .roadSign:
            return "road_sign_\(Int.random(in: 1...2))"
        }
    }
    
    static func trafficObjectImageName(object: TrafficObject) -> String {
        switch object {
        case .car:
            return "civil_car_\(Int.random(in: 1...3))"
        case .truck:
            return "truck"
        }
    }
    
    static func playersCarSkin(skinId: Int) -> String {
        return "car_\(skinId)"
    }
}

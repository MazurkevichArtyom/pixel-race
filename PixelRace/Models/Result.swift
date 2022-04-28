//
//  Result.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 24.04.2022.
//

import Foundation

struct Result: Codable {
    let difficulty: Difficulty
    let trafficCount: Int
    let timeDuration: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case difficulty
        case trafficCount
        case timeDuration
    }
}

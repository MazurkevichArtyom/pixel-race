//
//  GameplaySettings.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 19.04.2022.
//

import Foundation

struct Settings: Codable {
    var difficulty: Difficulty = .normal
    var skinId: Int = 1
    
    enum CodingKeys: String, CodingKey {
            case difficulty
            case skinId
        }
}

//
//  GameplaySettings.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 19.04.2022.
//

import Foundation

struct Settings: Codable {
    let difficulty: Difficulty
    let skin: String
    
    enum CodingKeys: String, CodingKey {
            case difficulty
            case skin
        }
}

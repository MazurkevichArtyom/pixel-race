//
//  Constants.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 24.04.2022.
//

import Foundation
import UIKit

struct Resources {
    struct UserDefaultsKeys {
        static let settings = "settings"
        static let resultFileName = "results"
    }
    
    struct Colors {
        static let mainBackgroundColor = UIColor(hex: 0x2E2E2E)
        static let mainTextColor = UIColor.white
        static let secondaryTextColor = UIColor(hex: 0x878787)
        static let sideColor = UIColor(hex: 0x76AC1F)
        static let laneColor = UIColor(hex: 0xA0A0A0)
        static let sideSeparatorColor = UIColor(hex: 0x787878)
        static let separateLineColor = UIColor.white
        static let separatorColor = UIColor(hex: 0x474747)
        static let roadEffectColor1 = UIColor(hex: 0x939393)
        static let roadEffectColor2 = UIColor(hex: 0xB0B0B0)
        static let sideEffectColor1 = UIColor(hex: 0x609E1B)
        static let sideEffectColor2 = UIColor(hex: 0x85C526)
    }
    
    struct Translates {
        static let settingsTitle = "settings_viewcontroller.title".localized()
        static let selectCarName = "settings_viewcontroller.select_car".localized()
        static let difficultyName = "settings_viewcontroller.difficulty".localized()
        static let leaderboardTitle = "leaderboard_viewcontroller.title".localized()
        static let carSectionName = "leaderboard_viewcontroller.car_section".localized()
        static let scoreSectionName = "leaderboard_viewcontroller.score_section".localized()
        static let dateSectionName = "leaderboard_viewcontroller.date_section".localized()
    }
}

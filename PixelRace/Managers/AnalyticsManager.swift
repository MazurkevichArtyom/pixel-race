//
//  AnalyticsManager.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 27.06.2022.
//

import Foundation
import FirebaseAnalytics

class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    func logScreenEvent(screen: AnalyticsScreen, className: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screen.rawValue,
            AnalyticsParameterScreenClass: className
        ])
    }
}

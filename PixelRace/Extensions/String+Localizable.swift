//
//  String+Localizable.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 25.05.2022.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

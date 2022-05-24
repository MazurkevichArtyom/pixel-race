//
//  ResultsManager.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 24.04.2022.
//

import Foundation

class ResultsManager {
    private static let maxCountOfResults = 50
    
    static func saveResult(result: Result) {
        var resultsArray = [Result]()
        
        if let savedResults = savedResults() {
            resultsArray = savedResults
        }
        
        resultsArray.insert(result, at: 0)
        
        if resultsArray.count > maxCountOfResults {
            resultsArray.remove(at: resultsArray.count - 1)
        }
        
        if let pathWithFileName = resultPath() {
            let data = try? JSONEncoder().encode(resultsArray)

            do {
                try data?.write(to: pathWithFileName)
            } catch {
            }
        }
    }
    
    static func savedResults() -> [Result]? {
        if let pathWithFileName = resultPath() {
            if FileManager.default.fileExists(atPath: pathWithFileName.path) {
                if let savedData = try? Data(contentsOf: pathWithFileName) {
                    let result = try? JSONDecoder().decode([Result].self, from: savedData)
                    return result
                }
            }
        }
        
        return nil
    }
    
    private static func resultPath() -> URL? {
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFileName = directory.appendingPathComponent(Resources.Strings.resultFileName)
            return pathWithFileName
        }
        
        return nil
    }
}

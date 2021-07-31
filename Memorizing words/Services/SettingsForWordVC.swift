//
//  SettingsForWordVC.swift
//  Memorizing words
//
//  Created by Andrey on 25.06.2021.
//

import Foundation

class SettingsForWordVC {
    
    static let shared = SettingsForWordVC()
    private init(){}
    
    var showTranslate = true
    var showTimer = true
    var boldMainWord = false
    
    var timerInterval = [1,2,3,4,5,6,7,8,9,10]
    var selectedTimerInterval = 3
    
    var wordSize = [40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90]
    var selectedWordSize = 60
    
    func findIndexForArrayOfTime() -> Int {
        var index = 0
        for i in 0..<timerInterval.count {
            if timerInterval[i] == selectedTimerInterval {
                index = i
            }
        }
        return index
    }
    
    func findIndexForArrayOfWord() -> Int {
        var index = 0
        for i in 0..<wordSize.count {
            if wordSize[i] == selectedWordSize {
                index = i
            }
        }
        return index
    }
}

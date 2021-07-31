//
//  StartingDownloadData.swift
//  Memorizing words
//
//  Created by Andrey on 30.06.2021.
//

import Foundation
import RealmSwift

class StartingDownloadData {
    
    static let shared = StartingDownloadData()
    private init(){}
    
    private let userDefaults = UserDefaults.standard
    
    var isAlreadyUploaded = false
    
    var fridge = Word(value: ["Fridge", "Холодильник"])
    var table = Word(value: ["Table", "Стол"])
    var сhair = Word(value: ["Сhair", "Стул"])
    var сup = Word(value: ["Cup", "Кружка"])
    var spoon = Word(value: ["Spoon", "Ложка"])
    var fork = Word(value: ["Fork", "Вилка"])
    
    var cat = Word(value: ["Cat", "Кот"])
    var dog = Word(value: ["Dog", "Собака"])
    var crocodile = Word(value: ["Сrocodile", "Крокодил"])
    var сow = Word(value: ["Cow", "Корова"])
    var mouse = Word(value: ["Mouse", "Мышь"])
    var bird = Word(value: ["Bird", "Птица"])
    var lion = Word(value: ["Lion", "Лев"])
    var elephant = Word(value: ["Elephant", "Слон"])
    
    func doStartData(){
        
        if let check = userDefaults.value(forKey: "check") as? Bool {
            return
        }
        
        if isAlreadyUploaded == false {
            var house = Topic(value: ["House", [fridge, table, сhair, сup, spoon, fork]])
            var aminals = Topic(value: ["Aminals", [cat, dog, crocodile, сow, mouse, bird, lion, elephant]])
            
            StorageManager.shared.save(topic: house)
            StorageManager.shared.save(topic: aminals)
            
            isAlreadyUploaded = true
            let boolData = try! JSONEncoder().encode(isAlreadyUploaded)
            userDefaults.set(isAlreadyUploaded, forKey: "check")
        }
    }
}



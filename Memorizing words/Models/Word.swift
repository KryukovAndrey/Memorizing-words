//
//  Word.swift
//  Memorizing words
//
//  Created by Andrey on 23.06.2021.
//

import Foundation
import RealmSwift

class Word: Object {
    @objc dynamic var englishWord = ""
    @objc dynamic var russianWord = ""
    @objc dynamic var level = ""
}

class Topic: Object {
    @objc dynamic var name = ""
    var words = List<Word>()
}

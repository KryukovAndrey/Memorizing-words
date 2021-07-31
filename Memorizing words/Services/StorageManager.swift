//
//  StorageManager.swift
//  Memorizing words
//
//  Created by Andrey on 23.06.2021.
//

import RealmSwift

class StorageManager{
    
    static let shared = StorageManager()
    let realm = try! Realm()
    private init (){}
    
    // MARK: - Private func
    private func write(_ completion: () -> Void) {
        do{
            try realm.write {
                completion()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - For Topics
    func save(topic: Topic){
        write {
            realm.add(topic)
        }
    }
    
    func delete(topic: Topic){
        write {
            realm.delete(topic)
        }
    }
    
    func edit(topic: Topic, newTopic: String){
        write {
            topic.name = newTopic
        }
    }
    
    // MARK: - For Words
    func save(topic: Topic, word: Word){
        write {
            topic.words.append(word)
        }
    }
    
    func delete(word: Word){
        write {
            realm.delete(word)
        }
    }
    
    func edit(word: Word, newEnglishWord: String, newRussianWord: String){
        write {
            word.englishWord = newEnglishWord
            word.russianWord = newRussianWord
        }
    }
}

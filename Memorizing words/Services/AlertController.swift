//
//  AlertController.swift
//  Memorizing words
//
//  Created by Andrey on 23.06.2021.
//

import UIKit

class AlertController: UIAlertController {
    
    var doneButton = "Save"
        
    func action(with topic: Topic?, completion: @escaping (String) -> Void) {
        
        if topic != nil { doneButton = "Update" }
                
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newTopicName = self.textFields?.first?.text else { return }
            guard !newTopicName.isEmpty else { return }
            completion(newTopicName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "Topic Name"
            textField.text = topic?.name
        }
    }
    
    func action(with word: Word?, completion: @escaping (String, String) -> Void) {
        
        if word != nil { doneButton = "Update" }
                        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newEnglishWord = self.textFields?.first?.text else { return }
            guard !newEnglishWord.isEmpty else { return }
            guard let newRussianWord = self.textFields?.last?.text else { return }
            guard !newRussianWord.isEmpty else { return }
            completion(newEnglishWord, newRussianWord)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "English word"
            textField.text = word?.englishWord
        }
        
        addTextField { textField in
            textField.placeholder = "Russian word"
            textField.text = word?.russianWord
        }
    }
    
    func delete(completion: @escaping () -> Void) {
                                
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            completion()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(deleteAction)
        addAction(cancelAction)
    }
}

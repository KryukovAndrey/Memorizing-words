//
//  WordsTableViewController.swift
//  Memorizing words
//
//  Created by Andrey on 23.06.2021.
//

import UIKit
import RealmSwift

class WordsTableViewController: UITableViewController, UISearchResultsUpdating {

    // MARK: - Public properties
    var topic: Topic!
    let searchController = UISearchController(searchResultsController: nil)
    
    var arrayOfWords: [Word] = []
    var filteredWords: [Word] = []

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfWords = Array(topic.words)

        title = topic.name
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addButtonPressed))
        let start = UIBarButtonItem(title: "Start",
                                    style: .done,
                                    target: self,
                                    action: #selector(goToWordViewController))

        navigationItem.rightBarButtonItems = [addButton, start]
        searchControllerParameters()
    }
    
    // MARK: - AddButtonPressed
    @objc private func addButtonPressed() {
        showAlert()
    }
    
    @objc private func goToWordViewController() {
        performSegue(withIdentifier: "goToWordVC", sender: topic)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? WordViewController else {return}
        dvc.topic = sender as? Topic
    }
    
    // MARK: - Public Methods

    func findIndexInArray(with word: Word, in array: [Word]) -> Int {
        var index = 0
        for i in 0..<array.count {
            if array[i].englishWord == word.englishWord {
                index = i
            }
        }
        return index
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredWords.count
        }
        return arrayOfWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)

        var word: Word?
        if isFiltering {
            word = filteredWords[indexPath.row]
        } else {
            word = arrayOfWords[indexPath.row]
        }
        
        cell.textLabel?.text = word?.englishWord
        cell.detailTextLabel?.text = word?.russianWord

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Swipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var word: Word?
        if isFiltering {
            word = filteredWords[indexPath.row]
        } else {
            word = arrayOfWords[indexPath.row]
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, isDone) in
            self.deleteAlert(word: word!, indexPath: indexPath)
            isDone(true)
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (_, _, isDone) in
            self.showAlert(with: word) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        editAction.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    // MARK: - Alert
    private func showAlert(with word: Word? = nil, completion: (() -> Void)? = nil) {
        
        let title = word != nil ? "Update" : "New Word"
        
        let alert = AlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        
        alert.action(with: word) { (newEnglishWord, newRussianWord) in
            if let word = word, let completion = completion {
                StorageManager.shared.edit(word: word, newEnglishWord: newEnglishWord, newRussianWord: newRussianWord)
                completion()
            } else {
                let word = Word()
                word.englishWord = newEnglishWord
                word.russianWord = newRussianWord
                
                DispatchQueue.main.async {
                    StorageManager.shared.save(topic: self.topic, word: word)
                    let rowIndex = IndexPath(row: self.topic.words.count - 1, section: 0)
                    self.arrayOfWords = Array(self.topic.words)
                    self.tableView.insertRows(at: [rowIndex], with: .automatic)
                }
            }
        }
        present(alert, animated: true)
    }
    
    private func deleteAlert(word: Word, indexPath: IndexPath) {
                
        let alert = AlertController(title: "Do you really want to delete word?", message: nil, preferredStyle: .alert)
        
        alert.delete {
            DispatchQueue.main.async {
                if self.isFiltering {
                    self.filteredWords.remove(at: indexPath.row)
                    self.arrayOfWords.remove(at: self.findIndexInArray(with: word, in: self.arrayOfWords))
                } else {
                    self.arrayOfWords.remove(at: indexPath.row)
                }
                StorageManager.shared.delete(word: word)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        present(alert, animated: true)
    }
    
    // MARK: - Search bar
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchControllerParameters(){
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Word"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "oval_static"), for: .normal)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        let array = Array(topic.words)
        filteredWords = array.filter { (word: Word?) -> Bool in
            return (word?.englishWord.lowercased().contains(searchText.lowercased()))! || (word?.russianWord.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
}


//
//  TopicsTableViewController.swift
//  Memorizing words
//
//  Created by Andrey on 23.06.2021.
//

import UIKit
import RealmSwift

class TopicsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - Public properties
    var topics: Results<Topic>!
    let searchController = UISearchController(searchResultsController: nil)
    
    var arrayOfTopics: [Topic] = []
    var filteredTopics: [Topic] = []

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
        
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async{
            StartingDownloadData.shared.doStartData()
            self.updaDataInController()
            self.tableView.reloadData()
        }
        searchControllerParameters()
    }

    // MARK: - IBAction
    @IBAction func  addButtonPressed(_ sender: Any) {
        showAlert()
    }
    
    // MARK: - Public Methods
    func updaDataInController(){
        self.topics = StorageManager.shared.realm.objects(Topic.self)
        self.arrayOfTopics = Array(self.topics)
    }
    
    func findIndexInArray(with topic: Topic, in array: [Topic]) -> Int {
        var index = 0
        for i in 0..<array.count {
            if array[i].name == topic.name {
                index = i
            }
        }
        return index
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTopics.count
        }
        return arrayOfTopics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath)

        var topic: Topic?
        if isFiltering {
            topic = filteredTopics[indexPath.row]
        } else {
            topic = arrayOfTopics[indexPath.row]
        }
        
        cell.textLabel?.text = topic?.name
        
        if let count = topic?.words.count {
            cell.detailTextLabel?.text = "\(count)"
        } else {
            cell.detailTextLabel?.text = "0"
        }

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? WordsTableViewController else {return}
        guard let indexPath = tableView.indexPathForSelectedRow else {return}

        var topic: Topic?
        if isFiltering {
            topic = filteredTopics[indexPath.row]
        } else {
            topic = arrayOfTopics[indexPath.row]
        }
        dvc.topic = topic
    }


    // MARK: - Swipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var topic: Topic?
        if isFiltering {
            topic = filteredTopics[indexPath.row]
        } else {
            topic = arrayOfTopics[indexPath.row]
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, isDone) in
            self.deleteAlert(topic: topic!, indexPath: indexPath)
            isDone(true)
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (_, _, isDone) in
            self.showAlert(with: topic) {
                DispatchQueue.main.async {
                    self.updaDataInController()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            isDone(true)
        }
        
        
        editAction.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    // MARK: - Alert
    private func showAlert(with topic: Topic? = nil, completion: (() -> Void)? = nil) {
        
        let title = topic != nil ? "Update" : "New Topic"
        
        let alert = AlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        
        alert.action(with: topic) { newValue in
            if let topic = topic, let completion = completion {
                StorageManager.shared.edit(topic: topic, newTopic: newValue)
                completion()
            } else {
                let topic = Topic()
                topic.name = newValue
                
                DispatchQueue.main.async {
                    StorageManager.shared.save(topic: topic)
                    self.updaDataInController()
                    self.tableView.reloadData()
                }
            }
        }
        present(alert, animated: true)
    }
    
    private func deleteAlert(topic: Topic, indexPath: IndexPath) {
                
        let alert = AlertController(title: "Do you really want to delete topic?", message: nil, preferredStyle: .alert)
        
        alert.delete {
            DispatchQueue.main.async {
                if self.isFiltering {
                    self.filteredTopics.remove(at: indexPath.row)
                    self.arrayOfTopics.remove(at: self.findIndexInArray(with: topic, in: self.arrayOfTopics))
                } else {
                    self.arrayOfTopics.remove(at: indexPath.row)
                }
                StorageManager.shared.delete(topic: topic)
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
        let array = Array(topics)
        filteredTopics = array.filter { (topic: Topic?) -> Bool in
            return (topic?.name.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
}


































// MARK: - Для первоначальной загрузки данных

//        var fridge = Word(value: ["Холодильник", "Fridge"])
//        var table = Word(value: ["Стол", "Table"])
//        var сhair = Word(value: ["Стул", "Сhair"])
//        var сup = Word(value: ["Кружка", "Cup"])
//        var spoon = Word(value: ["Ложка", "Spoon"])
//        var fork = Word(value: ["Вилка", "Fork"])
//
//        var house = Topic(value: ["House", [fridge, table, сhair, сup, spoon, fork]])
//
//        DispatchQueue.main.async {
//            StorageManager.shared.save(topic: house)
//            self.tableView.reloadData()
//        }

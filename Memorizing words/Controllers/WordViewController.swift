//
//  WordViewController.swift
//  Memorizing words
//
//  Created by Andrey on 24.06.2021.
//

import UIKit
import RealmSwift

class WordViewController: UIViewController {
    
    // MARK: - Public properties
    var topic: Topic?

    var numberOfWords = 0
    var timeForWord: Timer?
    var timeForTimeOut: Timer?
    var timeInterval = Int()
    var number = 0
    
    // MARK: - IBAction and IBOutlet
    
    @IBOutlet weak var mainWordLabel: UILabel!
    @IBOutlet weak var translateWordLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        timeInterval = SettingsForWordVC.shared.selectedTimerInterval
        sizeAndBoldFunc()
        updateUI()
        setupNavigationBar()
        timerLabel.text = "\(timeInterval)"
        showWord()
        timer()
        startUpdate()
        timerTime()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timeForWord?.invalidate()
        timeForTimeOut?.invalidate()
                
        timeForWord = nil
        timeForTimeOut = nil
    }

    // MARK: - Private func
    private func sizeAndBoldFunc(){
        if SettingsForWordVC.shared.boldMainWord {
            mainWordLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(SettingsForWordVC.shared.selectedWordSize))
        } else {
            mainWordLabel.font = UIFont.systemFont(ofSize: CGFloat(SettingsForWordVC.shared.selectedWordSize))
        }
    }
    
    // MARK: - Func for Timer of Word
    func showWord(){
        mainWordLabel.text = topic?.words[numberOfWords].englishWord
        translateWordLabel.text = topic?.words[numberOfWords].russianWord
    }
    
    func timer() {
        timeForWord = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval),
                                      target: self,
                                      selector: #selector(changeNumberOfWords),
                                      userInfo: nil,
                                      repeats: true)
    }
    
    @objc func changeNumberOfWords(){
        numberOfWords += 1
        if numberOfWords == topic?.words.count {
            numberOfWords = 0
        }
        showWord()
    }
    
    // MARK: - Func for Timer of Time
    
    func timerTime() {
        timeForTimeOut = Timer.scheduledTimer(timeInterval: 1,
                                      target: self,
                                      selector: #selector(changeNumberOfTime),
                                      userInfo: nil,
                                      repeats: true)
    }
    
    @objc func changeNumberOfTime(){
        number -= 1
        timerLabel.text = "\(number)"
        
        if number <= 1 {
            update()
        }
    }
    
    func startUpdate(){
        number = timeInterval
    }
    
    func update(){
        number = timeInterval + 1
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func updateUI(){
        translateWordLabel.isHidden = !SettingsForWordVC.shared.showTranslate
        timerLabel.isHidden = !SettingsForWordVC.shared.showTimer
    }
}

//
//  SettingsViewController.swift
//  Memorizing words
//
//  Created by Andrey on 25.06.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - IBAction and IBOutlet
    @IBOutlet weak var showTranslateSwitch: UISwitch!
    @IBOutlet weak var showTimerSwitch: UISwitch!
    @IBOutlet weak var boldSwitch: UISwitch!
    @IBOutlet weak var timerIntervalPickerView: UIPickerView!
    @IBOutlet weak var wordSizePickerView: UIPickerView!
    @IBOutlet weak var exampleLabel: UILabel!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        exampleLabel.isHidden = true
        showTranslateSwitch.isOn = SettingsForWordVC.shared.showTranslate
        showTimerSwitch.isOn = SettingsForWordVC.shared.showTimer
        boldSwitch.isOn = SettingsForWordVC.shared.boldMainWord
                
        timerIntervalPickerView.delegate = self
        timerIntervalPickerView.dataSource = self
        wordSizePickerView.delegate = self
        wordSizePickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timerIntervalPickerView.selectRow(SettingsForWordVC.shared.findIndexForArrayOfTime(), inComponent: 0, animated: true)
        wordSizePickerView.selectRow(SettingsForWordVC.shared.findIndexForArrayOfWord(), inComponent: 0, animated: true)
    }
    
    @IBAction func showTranslateSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            SettingsForWordVC.shared.showTranslate = true
        } else if sender.isOn == false {
            SettingsForWordVC.shared.showTranslate = false
        }
    }
    
    @IBAction func showTimerSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            SettingsForWordVC.shared.showTimer = true
        } else if sender.isOn == false {
            SettingsForWordVC.shared.showTimer = false
        }
    }

    @IBAction func boldSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            SettingsForWordVC.shared.boldMainWord = true
            exampleLabel.isHidden = false
            exampleLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(SettingsForWordVC.shared.selectedWordSize))
        } else if sender.isOn == false {
            SettingsForWordVC.shared.boldMainWord = false
            exampleLabel.isHidden = false
            exampleLabel.font = UIFont.systemFont(ofSize: CGFloat(SettingsForWordVC.shared.selectedWordSize))
        }
    }
}



// MARK: - Extension for PickerView
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == timerIntervalPickerView {
            SettingsForWordVC.shared.selectedTimerInterval = SettingsForWordVC.shared.timerInterval[row]
        } else if pickerView == wordSizePickerView {
            SettingsForWordVC.shared.selectedWordSize = SettingsForWordVC.shared.wordSize[row]
            exampleLabel.isHidden = false
            exampleLabel.font = exampleLabel.font.withSize(CGFloat(SettingsForWordVC.shared.selectedWordSize))
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == timerIntervalPickerView {
            return SettingsForWordVC.shared.timerInterval.count
        } else if pickerView == wordSizePickerView {
            return SettingsForWordVC.shared.wordSize.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == timerIntervalPickerView {
            return "\(SettingsForWordVC.shared.timerInterval[row])"
        } else if pickerView == wordSizePickerView {
            return "\(SettingsForWordVC.shared.wordSize[row])"
        } else {
            return "Ошибка"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var pickerLabel: UILabel? = (view as? UILabel)

        if pickerView == timerIntervalPickerView {
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.text = "\(SettingsForWordVC.shared.timerInterval[row])"
                pickerLabel?.font = UIFont(name: "Helvetica Neue", size: 17)
                pickerLabel?.textAlignment = .center
            }
        }
        
        if pickerView == wordSizePickerView {
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.text = "\(SettingsForWordVC.shared.wordSize[row])"
                pickerLabel?.font = UIFont(name: "Helvetica Neue", size: 17)
                pickerLabel?.textAlignment = .center
            }
        }
        return pickerLabel!
    }
}

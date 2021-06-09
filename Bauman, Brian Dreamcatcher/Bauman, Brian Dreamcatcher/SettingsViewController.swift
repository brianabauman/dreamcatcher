//
//  SettingsViewController.swift
//  Bauman, Brian Dreamcatcher
//
//  Created by Brian Bauman on 3/14/19.
//  Copyright © 2019 Brian Bauman. All rights reserved.
//

import UIKit

var settings: Settings = Settings()

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var alarmEnabledSwitch: UISwitch!
    @IBOutlet weak var alarmTimeDatePicker: UIDatePicker!
    @IBOutlet weak var snoozeMinutesLabel: UILabel!
    @IBOutlet weak var snoozeMinutesStepper: UIStepper!
    @IBOutlet weak var dreamEntryMinutesLabel: UILabel!
    @IBOutlet weak var dreamEntryMinutesStepper: UIStepper!
    @IBOutlet weak var tagPickerView: UIPickerView!
    @IBOutlet weak var newTagTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alarmEnabledSwitch.isOn = settings.alarmEnabled
        alarmTimeDatePicker.date = settings.alarmTime
        
        snoozeMinutesLabel.text = String(describing: settings.snoozeMinutes) + " min"
        snoozeMinutesStepper.value = Double(exactly: settings.snoozeMinutes) ?? 0.0
        
        dreamEntryMinutesLabel.text = String(describing: settings.dreamEntryMinutes) + " min"
        dreamEntryMinutesStepper.value = Double(exactly: settings.dreamEntryMinutes) ?? 0.0
    }
    
    @IBAction func alarmEnabledSwitchWasToggled(_ sender: UISwitch) {
        settings.alarmEnabled = sender.isOn
    }
    
    @IBAction func alarmTimeDatePickerWasChanged(_ sender: UIDatePicker) {
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeDateFormatter = DateFormatter()
        timeDateFormatter.dateFormat = "HH:mm:ss"
        
        settings.alarmTime = fullDateFormatter.date(from: "\(dayDateFormatter.string(from: Date())) \(timeDateFormatter.string(from: sender.date))")!
    }
    
    @IBAction func snoozeMinutesStepperWasPressed(_ sender: UIStepper) {
        snoozeMinutesLabel.text = String(format: "%.0f", sender.value) + " min"
        settings.snoozeMinutes = Int(exactly: sender.value) ?? 0
    }
    
    @IBAction func dreamEntryMinutesStepperWasPressed(_ sender: UIStepper) {
        dreamEntryMinutesLabel.text = String(format: "%.0f", sender.value) + " min"
        settings.dreamEntryMinutes = Int(exactly: sender.value) ?? 0
    }
    
    @IBAction func newTagOKButtonWasPressed() {
        if newTagTextField.text == "" {
            let alertController = UIAlertController(title: "Invalid data",
                                                    message: "Please enter a valid tag name.",
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } else {
            tags.append(newTagTextField.text!)
            tagPickerView.reloadAllComponents()
            newTagTextField.text = ""
        }
    }
    
    @IBAction func removeTagButtonPressed() {
        tags.remove(at: tagPickerView.selectedRow(inComponent: 0))
        tagPickerView.reloadAllComponents()
    }
    
    @IBAction func containerViewPressed(_ sender: UIControl) {
        newTagTextField.resignFirstResponder()
    }
    
    @IBAction func editEnded(_ sender: UITextField) {
        sender.resignFirstResponder();
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tags[row]
    }
}

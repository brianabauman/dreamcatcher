//
//  FilterDreamsViewController.swift
//  Bauman, Brian Dreamcatcher
//
//  Created by Brian Bauman on 3/14/19.
//  Copyright © 2019 Brian Bauman. All rights reserved.
//

import UIKit

class FilterDreamsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tagFilterSwitch: UISwitch!
    @IBOutlet weak var tagPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tagPickerView.isUserInteractionEnabled = tagFilterSwitch.isOn
    }
    
    @IBAction func clearButtonWasPressed() {
        filteredDreams = dreams
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tagSwitchWasToggled(sender: UISwitch) {
        tagPickerView.isUserInteractionEnabled = sender.isOn
    }
    
    @IBAction func submitButtonWasPressed() {
        filteredDreams = [Dream]()
        for dream in dreams {
            let tagMatch = tagFilterSwitch.isOn ? dream.tag == tags[tagPickerView.selectedRow(inComponent: 0)] : true
            let categoryMatch = categorySegmentedControl.selectedSegmentIndex == 2 ? true : dream.category == categorySegmentedControl.titleForSegment(at: categorySegmentedControl.selectedSegmentIndex)!.lowercased()
            
            if tagMatch && categoryMatch {
                print("debug: \(dream.title) match")
                filteredDreams.append(dream)
            } else {
                print("debug: \(dream.title) no match")
            }
        }
        
        dismiss(animated: true, completion: nil)
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

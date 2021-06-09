//
//  AddDreamViewController.swift
//  Bauman, Brian Dreamcatcher
//
//  Created by Brian Bauman on 3/14/19.
//  Copyright © 2019 Brian Bauman. All rights reserved.
//

import UIKit
import Speech

class AddDreamViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, SFSpeechRecognizerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tagPickerView: UIPickerView!
    @IBOutlet weak var newTagTextField: UITextField!
    
    var timer = Timer()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        microphoneButton.isEnabled = false
        speechRecognizer?.delegate = self
        
        //Brian Bauman: I copied a lot of this code from the internet and tweaked it a bit. I hope that's OK! I don't claim to have figured this all out on my own!
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        
        titleTextField.text = ""
        descriptionTextView.text = "Press the microphone to begin recording your dream. Press it again to stop recording."
        categorySegmentedControl.selectedSegmentIndex = 0
    }
    
    @IBAction func newTagOKButtonWasPressed() {
        if newTagTextField.text == "" {
            alertOnInvalidData(withMessage: "Please enter a valid tag name.")
        } else {
            tags.append(newTagTextField.text!)
            tagPickerView.reloadAllComponents()
            newTagTextField.text = ""
        }
    }
    
    @IBAction func submitButtonWasPressed() {
        let invalidTitleInd = (titleTextField.text == "")
        let invalidDescriptionInd = (descriptionTextView.text == "Press the microphone to begin recording your dream. Press it again to stop recording." || descriptionTextView.text == "")
        
        if (invalidTitleInd || invalidDescriptionInd) {
            alertOnInvalidData(withMessage: "Please enter a valid dream title and description.")
        } else {
            let dream = Dream(title: titleTextField.text!,
                              category: (categorySegmentedControl.selectedSegmentIndex == 0 ? "dream" : "nightmare"),
                              description: descriptionTextView.text,
                              tag: tags[tagPickerView.selectedRow(inComponent: 0)],
                              date: Date())
            dreams.append(dream)
            filteredDreams = dreams
            timer.invalidate()
            settings.alarmTime.addTimeInterval(TimeInterval(86400))
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonWasPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editEnded(_ sender: UITextField) {
        sender.resignFirstResponder();
    }
    
    @IBAction func containerViewPressed(_ sender: UIControl) {
        titleTextField.resignFirstResponder()
        newTagTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    @IBAction func microphoneButtonPressed() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setImage(UIImage(named: "microphone"), for: .normal)
            //microphoneButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            //microphoneButton.setTitle("Stop Recording", for: .normal)
        }
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
    
    func startRecording() {
        microphoneButton.setImage(UIImage(named: "recording"), for: .normal)
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record,
                                         mode: AVAudioSession.Mode.measurement,
                                         options: [])
            try audioSession.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.descriptionTextView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        descriptionTextView.text = "Say something, I'm listening!"
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    private func alertOnInvalidData(withMessage message: String) {
        let alertController = UIAlertController(title: "Invalid data",
                                                message: message,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

//
//  ViewController.swift
//  Bauman, Brian Dreamcatcher
//
//  Created by Brian Bauman on 3/13/19.
//  Copyright © 2019 Brian Bauman. All rights reserved.
//

import UIKit
import AVFoundation

class AlarmViewController: UIViewController {

    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var snoozeButton: UIButton!
    
    var timer = Timer()
    var player: AVAudioPlayer?
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let alarmDateFormatter = DateFormatter()
        alarmDateFormatter.dateFormat = "h:mm a"
        
        let clockDateFormatter = DateFormatter()
        clockDateFormatter.dateFormat = "h:mm:ss a"
        
        clockLabel.text = clockDateFormatter.string(from: Date())
        clockLabel.textColor = UIColor.lightGray
        stopButton.isEnabled = false
        snoozeButton.isEnabled = false
        
        if settings.alarmEnabled {
            alarmLabel.text = "Alarm at \(alarmDateFormatter.string(from: settings.alarmTime))"
        } else {
            alarmLabel.text = "Alarm disabled"
        }
        
        moveClock()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true) { _ in self.moveClock() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        player?.stop()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addDreamViewController = segue.destination as? AddDreamViewController {
            addDreamViewController.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(settings.dreamEntryMinutes * 60), repeats: false) { _ in
                addDreamViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func stopButtonWasPressed() {
        timer.invalidate()
    }
    
    @IBAction func snoozeButtonWasPressed() {
        settings.alarmTime = Date().addingTimeInterval(TimeInterval(settings.snoozeMinutes * 60))
        
        let alarmDateFormatter = DateFormatter()
        alarmDateFormatter.dateFormat = "h:mm a"
        alarmLabel.text = "Alarm at \(alarmDateFormatter.string(from: settings.alarmTime))"
        clockLabel.textColor = UIColor.lightGray
        stopButton.isEnabled = true
        snoozeButton.isEnabled = false
    }
    
    func moveClock() {
        if settings.alarmEnabled && Date() > settings.alarmTime {
            stopButton.isEnabled = true
            snoozeButton.isEnabled = true
            
            if clockLabel.textColor == UIColor.lightGray {
                clockLabel.textColor = UIColor.red
            } else {
                clockLabel.textColor = UIColor.lightGray
            }
            
            playSound()
        }
        
        let clockDateFormatter = DateFormatter()
        clockDateFormatter.dateFormat = "h:mm:ss a"
        clockLabel.text = clockDateFormatter.string(from: Date())
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}


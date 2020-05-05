//
//  AudioNoteViewController.swift
//  NoteTaker
//
//  Created by Ian McDonald on 02/05/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit
import AVFoundation

class AudioNoteViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder: AudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        audioRecorder = AudioRecorder(delegate: self)

    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if !audioRecorder.isRecording {
            audioRecorder.startRecording()
            recordButton.setTitle("Stop", for: .normal)
        } else {
            audioRecorder.finishRecording(success: true)
            recordButton.setTitle("Record", for: .normal)
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        audioRecorder.playRecording()
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        audioRecorder.pauseRecording()
        if audioRecorder.isRecording {
            pauseButton.setTitle("Pause", for: .normal)
        } else {
            pauseButton.setTitle("Paused", for: .normal)
        }
    }
}

extension AudioNoteViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            audioRecorder.finishRecording(success: false)
        }
    }
}

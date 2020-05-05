//
//  AudioRecorder.swift
//  NoteTaker
//
//  Created by Ian McDonald on 03/05/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import AVFoundation

class AudioRecorder {
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var delegate: AVAudioRecorderDelegate!
    
    var isRecording: Bool {
        guard audioRecorder != nil else { return false }
        return audioRecorder.isRecording
    }
    
    init(audioSession: AVAudioSession = .sharedInstance(), delegate: AVAudioRecorderDelegate) {
        self.audioSession = audioSession
        self.delegate = delegate
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            audioSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        // failed to initialize session
                        // add weak self if needed
                    }
                }
            }
        } catch {
            // failed to initialize session
        }
    }
    
    func startRecording() {
        let audioFilename = FileManager.getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = delegate
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    func pauseRecording() {
        guard audioRecorder != nil else { return }
        
        if audioRecorder.isRecording {
            audioRecorder.pause()
        } else {
            audioRecorder.record()
        }
    }
    
    func playRecording() {
        let audioFilename = FileManager.getDocumentsDirectory().appendingPathComponent("recording.m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.play()
        } catch {
            // error playing
        }
    }
}

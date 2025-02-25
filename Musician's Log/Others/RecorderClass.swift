//
//  RecorderClass.swift
//  Memory Lane (different project; I copied from myself)
//
//  Created by Bryce Sechrist on 2/18/25.
//

// Mostly borrowed from https://mdcode2021.medium.com/audio-recording-in-swiftui-mvvm-with-avfoundation-an-ios-app-6e6c8ddb00cc Great tutorial, but a bit outdated. I had to do a bit of adapting ;)

import AVFoundation
import Foundation

class RecorderClass : NSObject , ObservableObject , AVAudioPlayerDelegate {
    
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    @Published var isRecording : Bool = false
    @Published var isPlaying : Bool = false
    
    @Published var lastRecordedFileName: String? = ""
    @Published var recordingFileName : String? = ""
    
    @Published var timeElapsed : TimeInterval = 0
    @Published var recordingDuration : TimeInterval = 0
    
    private var sourceTimer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "update.timer")
    
    
    override init(){
        super.init()
        self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: self.queue)
    }
    
    //WARNING: DO NOT REMOVE!!! CAUSES THE PROGRAM TO CRASH FOR NO APPERANT REASON
    deinit {
        sourceTimer?.setEventHandler {}
        self.sourceTimer?.resume()
        
        sourceTimer?.cancel()
    }
    
    func startRecording(_ fileNamed: String){
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Can not setup the Recording")
        }
        
        
        let fileName = URL.documentsDirectory.appending(path: "\(fileNamed).m4a")
        
        
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
        } catch {
            print("Failed to Setup the Recording")
        }
        startTimer()
    }
    
    
    func stopRecording(){
        audioRecorder.stop()
        isRecording = false
        stopTimer()
    }
    
    func startPlaying(fileName : String) {
        let playSession = AVAudioSession.sharedInstance()
        
        do {
            try playSession.setCategory(.playAndRecord, mode: .default)
            try playSession.setActive(true)
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            
        } catch let error{
            print("this is the device error to make sure")
            print("Playing failed in Device \(error)")
        }
        
        do {
            let newPath = URL.documentsDirectory.appending(path: "\(fileName).m4a")
            audioPlayer = try AVAudioPlayer(contentsOf : newPath)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            isPlaying = true
            
        } catch let error {
            print("Playing Failed \(error.localizedDescription)")
            
        }
        lastRecordedFileName = fileName
        startTimer()
    }
    
    func stopPlaying(){
        
        audioPlayer.stop()
        isPlaying = false
        
        stopTimer()
    }
    func pausePlaying(){
        audioPlayer.pause()
        isPlaying = false
        stopTimer()
    }
    func unPausePlaying(){
        audioPlayer.play()
        isPlaying = true
        startTimer()
    }
    
    func playPause(_ fileName: String) {
        if isPlaying {
            pausePlaying()
        } else {
            if let oldFileName = lastRecordedFileName {
                if(oldFileName == fileName) {
                    unPausePlaying()
                    return
                }
            }
            startPlaying(fileName: fileName)
        }
        
        
    }
    func startTimer() {
        
        
        
        self.sourceTimer?.setEventHandler {
            self.updateTimer()
        }
        
        self.sourceTimer?.schedule(deadline: .now(),
                                   repeating: 0.01)
        
        self.sourceTimer?.resume()
    }
    func stopTimer() {
        self.sourceTimer?.suspend()
    }
    
    func updateTimer() {
        DispatchQueue.main.async {
            if let audioPlayer = self.audioPlayer {
                self.timeElapsed = audioPlayer.currentTime
            }
            if let audioRecorder = self.audioRecorder {
                self.recordingDuration = audioRecorder.currentTime
            }
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing")
        self.isPlaying = false
        self.stopTimer()
    }
    

    
    
}


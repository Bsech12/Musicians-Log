//
//  MetronomeController.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 1/24/25.
//

import Foundation

class MetronomeController: ObservableObject {
    
    @Published var isRunning: Bool = false
    private var sourceTimer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "stopwatch.timer")
    
    @Published var counter: Int = 0
    
    var beatsPerMinute: Int {
        didSet {
            resumeTimer(true)
        }
    }
    
    
    init(beatsPerMinute: Int = 120) {
        self.beatsPerMinute = beatsPerMinute
    }
    
    public func start() {
        if !(sourceTimer != nil) {
            self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: self.queue)
        }
        
        isRunning = true
        resumeTimer()
    }
    
    public func stop() {
        isRunning = false
        counter = 0
        pause()
    }
    
    private func pause() {
        self.sourceTimer?.suspend()
    }
    
    private func resumeTimer(_ isNew: Bool = false) {
        self.sourceTimer?.setEventHandler {
            self.updateTimer()
        }
        
        self.sourceTimer?.schedule(deadline: .now(),
                                   repeating: 60.0/Double(beatsPerMinute))
        print(60.0/Double(beatsPerMinute))
        if !isNew {
            self.sourceTimer?.resume()
        }
        
    }
    
    private func updateTimer() {
        DispatchQueue.main.async {
            self.counter += 1
        }
    }
}

//
//  TimerManager.swift
//  RestRoom
//
//  Created by user on 14.08.2024.
//
import Foundation

class TimerManager {
    private var timer: Timer?
    private var defaultTime: Int
    
    private(set) var seconds: Int
    
    var isTimerRunning: Bool {
        return timer != nil
    }
    
    var onTick: ((Int) -> Void)?
    var onTimerFinish: (() -> Void)?
    
    init(with time: Int) {
        self.defaultTime = time
        self.seconds = time
    }
    
    func start() {
        guard !isTimerRunning else { return }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
     func reset() {
        timer?.invalidate()
        timer = nil
        seconds = defaultTime
    }
    
    @objc private func updateTimer() {
        if seconds > 0 {
            seconds -= 1
            onTick?(seconds)
        } else {
            timer?.invalidate()
            timer = nil
            onTimerFinish?()
            reset()
        }
    }
}

//
//  TimeCounter.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 26/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Combine
import SwiftUI

//class MyTimer: ObservableObject {
//
//    static let shared = MyTimer()
//
//    private var timer: Timer?
//    var maxCounter: Int = 1500
//    @Published var counter = 0
//    @Published var isCounting = false
//
//
//    private init() { }
//
//
//    func startTimer() {
//        guard !isCounting else { return }
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementTimer), userInfo: nil, repeats: true)
//        self.isCounting = true
//    }
//
//
//    func pauseTimer() {
//        timer?.invalidate()
//        self.isCounting = false
//    }
//
//
//    func stopTimer() {
//        timer?.invalidate()
//        counter = 0
//        self.isCounting = false
//    }
//
//
//    @objc private func incrementTimer() {
//        counter += 1
//    }
//
//
//    deinit {
//        timer?.invalidate()
//        counter = 0
//    }
//
//}

class MyTimer {
    let currentTimePublisher = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
    let cancellable: AnyCancellable?

    init() {
        self.cancellable = currentTimePublisher.connect() as? AnyCancellable
    }

    deinit {
        self.cancellable?.cancel()
    }
}

//
//  AudioRecorder.swift
//  SwiftPulse
//
//  Created by Deep Bhupatkar on 21/09/24.
//

import Foundation
import SwiftUI
import AVFoundation

class AudioRecorder: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    @Published var audioLevel: CGFloat = 0.3
    
    init() {
        startRecording()
//        simulateAudioLevel()
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatAppleLossless),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
            ] as [String : Any]
            
            audioRecorder = try AVAudioRecorder(url: getAudioFileURL(), settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            
            startMonitoring()
            
        } catch {
            print("Failed to record: \(error)")
        }
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.audioRecorder?.updateMeters()
            let level = self.audioRecorder?.averagePower(forChannel: 0) ?? -160
            self.audioLevel = self.normalizedPowerLevel(fromDecibels: level)
        }
    }
    
    private func getAudioFileURL() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent("recording.m4a")
    }
    
    private func normalizedPowerLevel(fromDecibels decibels: Float) -> CGFloat {
        let minDecibels: Float = -80
        let clampedValue = max(minDecibels, decibels)
        let normalizedValue = (clampedValue + 80) / 80
        return CGFloat(normalizedValue)
    }
    
    func simulateAudioLevel() {
            // Simulate varying audio levels
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                self.audioLevel = CGFloat.random(in: 0.2...1.0)
            }
        }
    
    func stopRecording() {
        audioRecorder?.stop()
        timer?.invalidate()
    }
}

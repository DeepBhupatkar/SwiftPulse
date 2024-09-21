//
//  ContentView.swift
//  SwiftPulse
//
//  Created by Deep Bhupatkar on 21/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
            VoiceActivityIndicator()

        }
        .padding()
    }
}

struct VoiceActivityIndicator: View {
    @ObservedObject var audioRecorder = AudioRecorder()
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .frame(width: 150, height: 150)
                .foregroundColor(.blue)
                .scaleEffect(1 + audioRecorder.audioLevel * 0.9) // Adjust the scale with the audio level
                .animation(.easeInOut(duration: 0.1), value: audioRecorder.audioLevel) // Add smooth animation
        }
    }
}


#Preview {
    ContentView()
}

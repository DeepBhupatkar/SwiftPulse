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
            VoiceActivityIndicator()
        }
        .padding()
    }
}

struct VoiceActivityIndicator: View {
    @ObservedObject var audioRecorder = AudioRecorder()
    
    @State private var rotation: Double = 0
    @State private var eyeOffset: CGFloat = 0 // For eye movement
    
    var body: some View {
        ZStack {
            // Glowing effect using a blurred circle with the same gradient
              Circle()
                  .fill(
                      AngularGradient(
                          gradient: Gradient(colors: [.red, .blue, .green, .orange, .purple, .yellow]),
                          center: .center
                      )
                  )
                  .frame(width: 230, height: 230) // Slightly larger than the rotating circle
                  .blur(radius: 30) // Blur to create glow effect
                  .opacity(1.5) // Lower the opacity for a soft glow

            // Outer rotating colorful circle with varying line width
            Circle()
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [.red, .blue, .green, .orange, .purple, .yellow]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [10, 5], dashPhase: 10)
                )
                .frame(width: 250, height: 250)
                .rotationEffect(.degrees(rotation)) // Rotation effect
                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)
                .onAppear {
                    rotation = 360 // Start rotating the circle
                }


            // Inner circle that scales with audio level
            Circle()
                .fill(Color.black)
                .frame(width: 145, height: 145)
                .scaleEffect(1 + audioRecorder.audioLevel * 0.9) // Scaling with audio level
                .animation(.easeInOut(duration: 0.1), value: audioRecorder.audioLevel) // Smooth animation for audio level scaling
            
            // Eyes that move left and right
            HStack(spacing: 30) {
                Ellipse()
                    .fill(Color.white)
                    .frame(width: 35, height: 45)
                    .offset(x: eyeOffset)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: eyeOffset) // Eye animation
                

                Ellipse()
                    .fill(Color.white)
                    .frame(width: 35, height: 45) // Oval shape

                    .offset(x: eyeOffset)
                
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: eyeOffset) // Eye animation
            }
            .onAppear {
                // Move eyes left and right
                eyeOffset = 10 // The amount to move the eyes to the sides
            }
        }
    }
}

#Preview {
    ContentView()
}

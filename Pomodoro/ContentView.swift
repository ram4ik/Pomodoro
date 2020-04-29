//
//  ContentView.swift
//  Pomodoro
//
//  Created by Ramill Ibragimov on 25.04.2020.
//  Copyright © 2020 Ramill Ibragimov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var haptic = UserDefaults.standard.bool(forKey: "Haptic")
    @State private var sound = UserDefaults.standard.bool(forKey: "Sound")
    
    @State private var progress: CGFloat = 0
    @State private var run = false
    
    @State private var minutes = 360.0
    
    var colors = [Color.white.opacity(0.4), Color.white.opacity(0.4)]
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Color("Red")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Pomodoro")
                        .foregroundColor(Color.white.opacity(0.8))
                        .font(.largeTitle)
                        .fontWeight(.ultraLight)
                        .padding(40)
                }
                
                ZStack {
                    Circle()
                        .foregroundColor(Color("Red"))
                        .frame(width: 250, height: 250)
                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                        .shadow(color: Color.white.opacity(0.3), radius: 2, x: -2, y: -2)
                    
                    Circle()
                        .trim(from: 0, to: self.setProgress())
                        .stroke(AngularGradient(gradient: .init(colors: self.colors), center: .center, angle: .init(degrees: 180)), lineWidth: 100)
                        .frame(width: 150, height: 150)
                        .rotationEffect(.init(degrees: -90))
                    
                    Circle()
                        .foregroundColor(Color("Red"))
                        .frame(width: 150, height: 150)
                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                        .shadow(color: Color.white.opacity(0.3), radius: 2, x: -2, y: -2)
                    
                    VStack(alignment: .center) {
                        HStack {
                            withAnimation(Animation.default.speed(0.2)) {
                                Text(" \(200 - Int(self.progress)) ")
                                    .foregroundColor(Color.white.opacity(0.8))
                                    .font(.largeTitle)
                                    .bold()
                            }
                        }
                        HStack {
                            Text("secs")
                                .foregroundColor(Color.white.opacity(0.8))
                        }
                    }
                }
                
                VStack {
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.white)
                            .opacity(0.1)
                            .frame(width: 360, height: 4)
                            .cornerRadius(4)

                        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                            .frame(width: CGFloat(minutes), height: 4)

                    }
                    HStack {
                        Text("0")
                        Spacer()
                        Text("20 min")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .frame(width: 360)
                }
                .padding(.top, 10)
                
                Button(action: {
                    self.run.toggle()
                    if self.haptic {
                        self.haptics.notificationOccurred(self.haptic ? .success : .warning)
                    }
                    if self.sound {
                        playSound(sound: self.run ? "Cartoon sound effects ping 1" : "Cartoon sound effects zip 4", type: "wav")
                    }
                }) {
                    Text(self.run ? "Pause" : "Start")
                        .foregroundColor(Color.white.opacity(0.8))
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                }.background(Capsule().stroke(LinearGradient(gradient: .init(colors: colors), startPoint: .leading, endPoint: .trailing), lineWidth: 2))
                .padding(55)
            }
            
            VStack {
                HStack {
                    Image(systemName: "gear")
                        .foregroundColor(Color.white.opacity(0.4))
                        .padding()
                        .contextMenu {
                            Button(action: {
                                self.haptic.toggle()
                                UserDefaults.standard.set(self.haptic, forKey: "Haptic")
                            }) {
                                Text("Haptic feedback")
                                Image(systemName: self.haptic ? "checkmark.circle" : "xmark.circle")
                            }
                            Button(action: {
                                self.sound.toggle()
                                UserDefaults.standard.set(self.sound, forKey: "Sound")
                            }) {
                                Text("Sound feedback")
                                Image(systemName: self.sound ? "checkmark.circle" : "xmark.circle")
                            }
                        }
                    Spacer()
                    Image(systemName: "info.circle")
                        .foregroundColor(Color.white.opacity(0.4))
                        .padding()
                        .contextMenu {
                            Text("Pomodoro")
                        }
                }
                Spacer()
            }
        }.onReceive(timer, perform: updateTimer)
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
    }
    
    func setProgress() -> CGFloat {
        let temp = self.progress / 2
        return temp * 0.01
    }
    
    func updateTimer(_ currentTime: Date) {
        if self.run {
            withAnimation(Animation.default.speed(0.55)) {
                if self.progress != 200 {
                    self.progress += 1
                }
                
                if self.minutes != 0 {
                    self.minutes -= 0.3
                }
                
                if self.minutes == 0 {
                    self.run = false
                    self.minutes = 360.0
                    playSound(sound: "Bang, bell and fall", type: "wav")
                    haptics.notificationOccurred(.error)
                }
            }
            if self.progress == 200 {
                self.progress = 0
                playSound(sound: "Comedy effect clang", type: "wav")
                haptics.notificationOccurred(.success)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

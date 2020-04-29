//
//  PlaySound.swift
//  Pomodoro
//
//  Created by Ramill Ibragimov on 29.04.2020.
//  Copyright © 2020 Ramill Ibragimov. All rights reserved.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Error: Could not find any play the sound file!")
        }
    }
}

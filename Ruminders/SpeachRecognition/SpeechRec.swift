//
//  SpeechRec.swift
//  SpeechToTextDemo
//
//  Created by Altynbek Usenbekov on 1/8/20.
//  Copyright © 2020 Altynbek Usenbekov. All rights reserved.
//

import Foundation
import Speech

class SpeechRec: ObservableObject {
    @Published private(set) var recognizedText = ""
    @Published private(set) var isRunning = false
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU")) // Use Russian
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    func start() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                self.startRecognition()
            }
        }
    }
    
    func startRecognition() {
        do {
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { return }
            
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                if let result = result {
                    self.recognizedText = result.bestTranscription.formattedString
                }
            }
            
            let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                recognitionRequest.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            self.recognizedText = "Слушаю..."
            self.isRunning = true
        }
        
        catch {
            
        }
    }
    
    func stop() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionRequest?.endAudio()
        self.isRunning = false
    }
}

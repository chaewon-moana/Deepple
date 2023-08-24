//
//  OrderButtonView.swift
//  hackerton
//
//  Created by Cho Chaewon on 2023/08/17.
//

import AVFoundation
import SwiftUI
import Speech

class SpeechManager: ObservableObject {
    @Published var outputText = ""
    @Published var isRecording = false
    
    private var audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    init() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
    }
    
    func startRecording() {
        isRecording = true
        outputText = ""
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.outputText = result.bestTranscription.formattedString
            } else if let error = error {
                print("인식 실패 - \(error)")
            }
        }
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine - Error : \(error)")
        }
    }
    
    func stopRecording() {
        isRecording = false
        recognitionRequest?.endAudio()
        audioEngine.stop()
        recognitionTask?.cancel()
    }
}

struct OrderButtonView: View {
    @StateObject private var speechManager = SpeechManager()
    
    var body: some View{
        VStack {
            Text(speechManager.outputText)
                .padding()
            
            Button(action: {
                if speechManager.isRecording {
                    speechManager.stopRecording()
                } else {
                    speechManager.startRecording()
                }
            }) {
                Text(speechManager.isRecording ? "녹음 중단" : "녹음 시작")
            }
        }
        
        RoundedRectangle(cornerRadius: 32)
        //.frame(width: 464, height: 604)
        
    }
    
    
}

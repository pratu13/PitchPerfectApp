//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Pratyush Sharma on 23/06/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        do{
        audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        } catch {
            print("Error")
        }

        // Do any additional setup after loading the view.
//        if let filepath = Bundle.main.path(forResource: "052004" , ofType: "mp3")
//        {
//           let filepathurl = NSURL.fileURL(withPathComponents: [filepath])
//        }
//        else{
//            print("The file is empty");
//        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
            audioPlayer.enableRate = true
        } catch {
            // handle error
            print("Error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stop(_ sender: UIButton) {
        audioPlayer.stop()
    }
    @IBAction func slowRecord(_ sender: UIButton) {
            audioPlayer.stop()
            audioPlayer.rate = 0.5
            audioPlayer.currentTime = 0.0
            audioPlayer.play()
    }
    
    @IBAction func fastPlay(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    
    @IBAction func chipmunkVoice(_ sender: UIButton) {
        playAudioWithVariablePitch(pitch: 1000)
    }
    func playAudioWithVariablePitch(pitch: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do{
              try audioEngine.start()
        }catch{ print("Error")}
      
        audioPlayerNode.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

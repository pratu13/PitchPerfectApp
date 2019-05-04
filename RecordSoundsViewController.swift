//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Pratyush Sharma on 22/06/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!

    @IBOutlet weak var recording: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        stopButton.isHidden = true
    }
    //Interface Buider (not an ordinary button, linked to the story board)
    @IBAction func RecordAudio(_ sender: UIButton) {
        stopButton.isHidden = false
        recording.isHidden = false
        //TODO : Record Audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let currentTime = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentTime as Date)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        print("Recording...")
        
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
        //Save the recorded audio
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url as NSURL
            recordedAudio.title = recorder.url.lastPathComponent
        //Switch to the next page
        self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        }
        else{
            print("Recording was not successful");
            stopButton.isHidden = true
            recording.isEnabled = true
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if( segue.identifier == "stopRecording")
        {
            let playSoundVC:PlaySoundViewController = segue.destination as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    @IBAction func stop(_ sender: UIButton) {
        recording.isHidden = true
        stopButton.isHidden = true
        print("Recorded")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        //TODO : Save the recording
        
        
    }
}


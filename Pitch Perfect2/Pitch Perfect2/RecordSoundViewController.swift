//
//  RecordSoundViewController.swift
//  Pitch Perfect2
//
//  Created by Dori Frost on 3/1/15.
//  Copyright (c) 2015 Dori.Frost. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordingPaused: UILabel!
    @IBOutlet weak var tapToRecord: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var pausedFlag = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        setViewLabels (false, recordingInProgressHide: true, recordingPausedHide: true)
        setViewButtons (true, pauseButtonHide: true, recordButtonHide: false)
    }

    @IBAction func recordAudio(sender: UIButton) {
        println("in recordAudio")
        
        setViewLabels (true, recordingInProgressHide: false, recordingPausedHide: true)
        setViewButtons (false, pauseButtonHide: false, recordButtonHide: true)
        
        if (pausedFlag == true) {
            audioRecorder.record()
            pausedFlag = false
        } else {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            pausedFlag = false
        }
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        println("in pauseAudio")
        
        setViewLabels (true, recordingInProgressHide: true, recordingPausedHide: false)
        setViewButtons (false, pauseButtonHide: true, recordButtonHide: false)
        
        audioRecorder.pause()
        pausedFlag = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!) 
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)
    }
    
    func setViewLabels (tapToRecordHide: Bool, recordingInProgressHide: Bool, recordingPausedHide: Bool) {
        tapToRecord.hidden = tapToRecordHide
        recordingInProgress.hidden = recordingInProgressHide
        recordingPaused.hidden = recordingPausedHide
      }
    
    func setViewButtons (stopButtonHide: Bool, pauseButtonHide: Bool, recordButtonHide: Bool) {
        stopButton.hidden = stopButtonHide
        pauseButton.hidden = pauseButtonHide
        recordButton.hidden = recordButtonHide
    }
    
    
    
}


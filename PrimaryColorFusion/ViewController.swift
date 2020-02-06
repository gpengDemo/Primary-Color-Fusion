//
//  ViewController.swift
//  PrimaryColorFusion
//
//  Created by 辜鹏 on 2019/10/9.
//  Copyright © 2019 PengGu. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
class ViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer?
    
    @IBOutlet weak var playbtn: UIBarButtonItem!

    var button:UIButton?
    
    var pauseFlag = false {
         
         willSet {
             
            // play
             if newValue {
                
                button?.setImage(UIImage(named: "music_1"), for: .normal)

                 
             } else {
                
             // pause
                
                button?.setImage(UIImage(named: "music_2"), for: .normal)
                
//                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "closemusic")))



             }
         }
     }

    
//    @objc func playmusic() {
//        self.audioPlayer?.play()
//
//    }
//
//    @objc func musicclose() {
//        self.audioPlayer?.pause()
//
//    }

    
    @objc func playMusic() {
        
        pauseFlag = !pauseFlag
        UserDefaults.standard.set(pauseFlag, forKey: "flag")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        UserDefaults.standard.set(pauseFlag, forKey: "flag")
        

//
//        let path = Bundle.main.path(forResource: "bgmusic", ofType: "mp3")
//        let pathURL = NSURL(fileURLWithPath: path!)
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: pathURL as URL)
//        } catch {
//            audioPlayer = nil
//        }
//        audioPlayer?.prepareToPlay()
//        audioPlayer?.numberOfLoops = -1

//        NotificationCenter.default.addObserver(self, selector: #selector(playmusic), name: Notification.Name.init(rawValue: "playmusic"), object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(musicclose), name: Notification.Name.init(rawValue: "musicclose"), object: nil)

    }


    func setupUI()  {
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .black
        
        
        button = UIButton.init(type: .custom)
        button!.setImage(UIImage.init(named: "music_2"), for: .normal)
        button!.addTarget(self, action:#selector(ViewController.playMusic), for:.touchUpInside)
        button!.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        
        let barButton = UIBarButtonItem.init(customView: button!)
        self.navigationItem.rightBarButtonItem = barButton

        
        
    }
    
    
}


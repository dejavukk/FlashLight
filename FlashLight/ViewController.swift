//
//  ViewController.swift
//  FlashLight
//
//  Created by JunHyuk on 2018. 9. 4..
//  Copyright © 2018년 junhyuk. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // * 스위치 isOn, soundPlayer 변수 선언.
    var isOn = false
    var soundPlayer: AVAudioPlayer?
    
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var flashImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSound()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // * 사운드 구현 함수
    func prepareSound() {
        
        let path = Bundle.main.path(forResource: "switch.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.play()
        } catch {
            // couldn't load file :(
        }
        
    }
    
    // * 실제 기기에서 플래시 On/Off 구현.
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    // * 스위치를 Tap 했을 때 플래시 On/Off.
    @IBAction func switchTapped(_ sender: UIButton) {
        
        isOn = !isOn
        toggleTorch(on: isOn)
        
        soundPlayer?.play()
        
        if isOn == true {
            switchButton.setImage(UIImage(named: "onSwitch"), for: .normal)
            flashImageView.image = #imageLiteral(resourceName: "onBG")
            
        } else {
            switchButton.setImage(#imageLiteral(resourceName: "offSwitch"), for: .normal)
            flashImageView.image = UIImage(named: "offBG")
        }
        
        /* 위에 스위치 키고 끄는 기능과 같은 표현이다.
        
         flashImageView.image = isOn ? #imageLiteral(resourceName: "onBG") : #imageLiteral(resourceName: "offBG")
         switchButton.setImage(isOn ? #imageLiteral(resourceName: "onSwitch") : #imageLiteral(resourceName: "offSwitch"), for: .normal)
         
         */
        
    }
    
}


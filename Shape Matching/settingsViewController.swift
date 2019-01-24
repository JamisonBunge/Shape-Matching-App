//
//  settingsViewController.swift
//  Shape Matching
//
//  Created by Jamison Bunge on 1/9/19.
//  Copyright © 2019 Jamison Bunge. All rights reserved.
//

import Foundation
import UIKit

class settingsViewController : UIViewController {
    
    @IBOutlet weak var tempAmountController: UIStepper!
    @IBOutlet weak var AmountLabel: UILabel!
    
    @IBOutlet weak var musicSwitch: UISwitch!
    
    @IBOutlet weak var soundSwitch: UISwitch!
    var game : ViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game = self.presentingViewController as? ViewController
        
    //game!.score.text = "steve"
       
        tempAmountController.value = Double(game!.amountOfShapes)
        tempAmountController.minimumValue = 3
        tempAmountController.maximumValue = 6
        AmountLabel.text = String(game!.amountOfShapes)
        
        
        if !(game!.audioPlayer.isPlaying) {
            musicSwitch.setOn(false, animated: false)
        }
        
        if (game!.sound == false) {
            print("dd")
            soundSwitch.setOn(false, animated: false)
        }
        

    }
    
    @IBAction func updateCounter(_ sender: Any) {
        AmountLabel.text = String(String(tempAmountController.value).first!)
    }
    
    @IBAction func flipSound(_ sender: Any) {
        if soundSwitch.isOn {
            game?.sound = true
        } else {
            game?.sound = false
        }
    }
    
    @IBAction func flipMusic(_ sender: Any) {
        
        
        if musicSwitch.isOn {
            game?.audioPlayer.play()
        } else {
            game?.audioPlayer.pause()
        }
    }
    @IBAction func goback(_ sender: Any) {
        
        let shapeAmount = Int(tempAmountController.value)
        if shapeAmount != game?.amountOfShapes  {
            game!.amountOfShapesChanged(newAmount: shapeAmount)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tempAmtCntr(_ sender: Any) {
        
    }
    
}

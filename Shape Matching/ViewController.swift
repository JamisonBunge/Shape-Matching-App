//
//  ViewController.swift
//  Shape Matching
//
//  Created by Jamison Bunge on 11/19/18.
//  Copyright © 2018 Jamison Bunge. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {

    @IBOutlet weak var dock: UIImageView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var settings: UIButton!
   
    
    
    
    lazy var instance: ModelGame? = ModelGame(size: amountOfShapes, dockPassed: dock)
    
    var audioPlayer = AVAudioPlayer()
    var placedSFX = AVAudioPlayer()
    var sound: Bool = true
    
    var zoneX : (CGFloat, CGFloat) = (0,0)
    var zoneY : (CGFloat, CGFloat) = (0,0)
    
    var pegAspectRatio : CGFloat = 0
    var shapeAspectRatio : CGFloat = 0
    var gridCoords : [(x: CGFloat, y: CGFloat)] = [(0,0)]

    var amountOfShapes = 3
    var shapesLeft : Int = 100 {
        didSet {
            if(shapesLeft == 0) {
                shapesLeft = amountOfShapes
                
                for shape in instance!.setOfShapes {
                    UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                        shape.shapeImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    })
                }
                DispatchQueue.main.asyncAfter(deadline: .now() +  0.75) {
                    self.newGame()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicInit() //turn off for now
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  print("image dock:\(dock.frame.width) game dock: \(instance!.dock.peggedMaxX - instance!.dock.peggedMinX)")
        generatePegZone()
        shapesLeft = amountOfShapes
        dock.tag = 5
        generateSafePlacementGrid()
        constructView(numberOfShapes: amountOfShapes)
    }
    

    func amountOfShapesChanged(newAmount: Int) {
        
        //Check to see if the game is ready to be reset,
            //if it is not, do not do it,
        //TODO: how do I correct this on the other side? Does it know that the new game did not happen?
        if (instance!.isReady) {
       
            //"instance" is going to be modified, turn this to false to let the other functions know that it isnt ready
            instance!.isReady = false
      
       //Animate the shapes off the screen
            //TODO: I have to completly redo how this app handles delays and animations
            
        
        //Animate the actors offscrean
        for shape in instance!.setOfShapes {
            
            UIView.animate(withDuration: 0.75, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            shape.shapeImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)   //Scale the shapes down so they can not be seen
            },
                completion: {(finished:Bool) in
                    shape.shapeImage.image = nil                                        //set the image to nothing
                    shape.shapeImage.removeFromSuperview()                              //remove it fromt the view as clean-up
                    })
            
            UIView.animate(withDuration: 0.75, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                shape.pegImage.center = CGPoint(
                    x: shape.pegImage.center.x-400,
                    y: self.dock.center.y - 400)    //TODO: all of these -400 things so they consider the screen size,
                                                            //this is necissarly for making this work for iPad as well
            },
                    completion: {(finished:Bool) in
                        shape.pegImage.image = nil
                        shape.pegImage.removeFromSuperview()
                        })
        }
        
        //update the amount of shapes
        amountOfShapes = newAmount
            
            //TODO: are delays like this okay? I need this stuff to take place after the animations are done
            //TODO: ask this qustion on the subreddit
        DispatchQueue.main.asyncAfter(deadline: .now() +  1) { // newGame actions
            //TODO: potentially generlize newGame, constructView, and amountOfShapesChanged to be simpler and work together.
    
            
            self.instance = nil             //delete the current instance
            shapeNames = fullShapeList      // reset the 'sudo'-database
            self.instance = ModelGame(size: self.amountOfShapes, dockPassed: self.dock) // reinit with the new size
            self.generatePegZone()              //generate z-space
            self.generateSafePlacementGrid()    //get grid coords
            self.shapesLeft = self.amountOfShapes   //update shapesLeft
            self.constructView(numberOfShapes: self.amountOfShapes) //this brings the shapes to life
            }
        }
    }
    

    func generateSafePlacementGrid() {
        
        //reset the grid
        gridCoords.removeAll()
        
        let zSpaceHeight = zoneY.1 - zoneY.0
        let zSpaceWidth = zoneX.1 - zoneX.0
        
        let numberOfYLines =  Int(zSpaceHeight / pegAspectRatio)
        let numberOfXLines =  Int(zSpaceWidth / pegAspectRatio)
        
     //   print("number of y lines:\(numberOfYLines)")
   //     print("number of x lines:\(numberOfXLines)")
        
        //These offsets center the grid
        let xOffset = (zoneX.1 - (zoneX.0 + (CGFloat(numberOfXLines) * pegAspectRatio))) / 2
        let yOffset = (zoneY.1 - (zoneY.0 + (CGFloat(numberOfYLines) * pegAspectRatio))) / 2
        
        for i in 0...numberOfYLines {
            for j in 0...numberOfXLines {
                
                
                gridCoords.append((x: (xOffset + zoneX.0 + (CGFloat(j) * pegAspectRatio))
                                 , y: (yOffset + zoneY.0 + (CGFloat(i) * pegAspectRatio))))
                
        //        print(gridCoords.count)
//
//                print(i)
//                print(j)
//            let pegImage = UIImageView(image: nil)
//            pegImage.image = UIImage(named: "squareHat")
//            //hard coded width and height for now
//            pegImage.frame = CGRect(x: (zoneX.0 + (CGFloat(j) * pegAspectRatio)) , y: (zoneY.0 + (CGFloat(i) * pegAspectRatio)), width: pegAspectRatio, height: pegAspectRatio)
//            pegImage.center = CGPoint(x: (xOffset + zoneX.0 + (CGFloat(j) * pegAspectRatio)), y: (yOffset + zoneY.0 + (CGFloat(i) * pegAspectRatio)))
//            view.addSubview(pegImage)
            }
            
        }
        
    }
    
    func generatePegZone() {
        
        //62.5 is currently  pegImage.frame.width / 2
        
        
        //1 Create Zone
        //2 Generate Coords
        //3 Check for conflicts
        //4 Place Image
        //Update Model
        
        
        
        
        
        if (dock.frame.width / CGFloat(1 + amountOfShapes) > 70) {
            shapeAspectRatio = 70
           // print("yyoo")
        } else  {
            shapeAspectRatio = dock.frame.width / (1 + CGFloat(amountOfShapes))
      //      print("its me hello")
        }
       // shapeAspectRatio = dock.frame.width / (2 + CGFloat(amountOfShapes))
         pegAspectRatio = 1.5 * shapeAspectRatio
        
        print("Shape Size: \(shapeAspectRatio)")
        //1
     //   let screenWidth = UIScreen.main.bounds.width
     //   let screenHeight = UIScreen.main.bounds.height
        let dockWidth = dock.frame.width
        
     
        let x = UIView()
        x.backgroundColor = UIColor.blue
        x.frame = CGRect(x: dock.frame.minX, y: 75, width: dockWidth, height: dock.frame.minY-75)
     // view.addSubview(x)
        
       // print("x frame: \(x.frame.maxY)")
        
        
        
        let z = UIView()
        z.backgroundColor = UIColor.red
        z.frame = CGRect(x: dock.frame.minX + (pegAspectRatio/2), y: x.frame.minY + (pegAspectRatio/2), width: dockWidth - pegAspectRatio, height: x.frame.height - pegAspectRatio)
       // view.addSubview(z)
        
        let x1 = z.frame.minX ; let x2 = z.frame.maxX
        let y1 = z.frame.minY ; let y2 = z.frame.maxY
        
        
       // var someCord : CGFloat = CGFloat.random(in: x1...x2)
        
        zoneX = (x1,x2)
        zoneY = (y1,y2)
        
       // print("x:\(CGFloat.random(in: x1...x2)),y:\(CGFloat.random(in: y1...y2))")
        
    }
    
    func randomGridCord() -> (CGFloat, CGFloat) {
        var keepLooping = true
        var centerCords : (CGFloat, CGFloat) = (0.0,0.0)
        var loopcount = 1
        let gridCopy = gridCoords
        
        if(gridCoords.count < amountOfShapes) {
            print("fatal error: gridCoords.count < amountOfShapes")
        }
        
        while(keepLooping) {
    
            keepLooping = false
            let index = Int.random(in: 0..<gridCopy.count)
            centerCords = (gridCopy[index].x, gridCopy[index].y)
            
            if(instance!.setOfShapes.count != 0) {
                for shape in instance!.setOfShapes {
                    
                    let dummyImage = UIImageView()
                    dummyImage.frame = shape.pegImage.frame
                    dummyImage.center = CGPoint(x: centerCords.0, y: centerCords.1)
                    
                    if(shape.pegImage.frame.intersects(dummyImage.frame)) {
                        keepLooping = true
                    }
                }
            }
        }
        return centerCords
    }
    
    func randomCenterCords() -> (CGFloat, CGFloat) {
        
        var keepLooping = true
        var centerCords : (CGFloat, CGFloat) = (0.0,0.0)
        var loopcount = 1
        
        while(keepLooping) {
            
            keepLooping = false
           
            //generate coords
            centerCords = (CGFloat.random(in: zoneX.0...zoneX.1),
                           CGFloat.random(in: zoneY.0...zoneY.1))
            
          //,x:\(centerCords.0) y:\(centerCords.1)")
            loopcount = loopcount+1
            //check if there is an peg conflict
           //  print(instance.setOfShapes.count)
            
            
            if(instance!.setOfShapes.count != 0) {
            for shape in instance!.setOfShapes {
                
                let dummyImage = UIImageView()
                dummyImage.frame = shape.pegImage.frame
                dummyImage.center = CGPoint(x: centerCords.0, y: centerCords.1)
                
                if(shape.pegImage.frame.intersects(dummyImage.frame)) {
                    keepLooping = true
                }
//                if (loopcount == 300) {
//                    //put the first shape in a corner
//                    print("hit a corner")
//                    instance!.setOfShapes[0].pegImage.center = CGPoint(x: zoneX.0, y: zoneY.0)
//                }
            }
            }
        }
       // print("loops: \(loopcount)")
    return centerCords
    }
    
    func constructView(numberOfShapes: Int) {
        
        //Algorithm
        //1: Get slot locations on the dock
        //2: get slot locations on the aFrame
        //3: Create shapeImage
            //A: Set the frame size
            //B: Add the image as a subview
            //C: Place on the dock
        //4: Create peggedShape
            //A: Set the frame size
            //B: Add the image as a subview
            //C: place on aFrame
        
        //Notes
            //Image amount is currently hardcorded, 3
            //Frame dimentions are currently hardcoded, 75x75
      //  print(instance!.dock.peggedCenterX)
       // print(dock.center.x)
        
        
        //hard code get positions for now
        var positionsFromShelfCords : [CGFloat] = []
        let incrementLength = dock.frame.width / CGFloat(amountOfShapes + 1)
        
        //populate positions shelf Cord array
        for i in 1...amountOfShapes {
        
            positionsFromShelfCords.append(dock.frame.minX + (CGFloat(i) * incrementLength))
        }
        
   
       
       // print("YO")
       // print(dock.frame.width)
    //    print(shapeAspectRatio)
      //  print(pegAspectRatio)
        
        
        
        for i in 0..<amountOfShapes {
            
            //createImage
            let shapeImage = UIImageView(image: nil)
            
            //hard coded width and height for now
            shapeImage.frame = CGRect(x: 0, y: instance!.dock.shelfedCenterY, width: shapeAspectRatio, height: shapeAspectRatio)
            
            
            shapeImage.center = CGPoint(
                x: positionsFromShelfCords[i],
                y: dock.center.y
            )
             shapeImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
            let pegImage = UIImageView(image: nil)
            
            //hard coded width and height for now
            pegImage.frame = CGRect(x: 0, y: instance!.dock.shelfedCenterY, width: pegAspectRatio, height: pegAspectRatio )
            
            
            let pegCenter = randomGridCord()
            
            pegImage.center = CGPoint(
                x: pegCenter.0,
                y: pegCenter.1
            )
            
           // pegImage.backgroundColor = UIColor.gray
            
            //set UI Properties
            shapeImage.isUserInteractionEnabled = true
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            shapeImage.addGestureRecognizer(gestureRecognizer)
            
            
            
           
            //put it in the model
            instance!.addShape(shape: shapeImage, peg: pegImage)
           
           
          
            
        }
        //set shapes
        for object in instance!.setOfShapes {
            setImage(liveShape: object)
        }
        for shape in instance!.setOfShapes {
            //temp
            
            //shape.pegImage.backgroundColor = UIColor.gray
           view.addSubview(shape.pegImage)
            shape.pegImage.center = CGPoint(
                x: shape.peggedCenterX+400,
                y: shape.peggedCenterY
            )
        }
        for shape in instance!.setOfShapes {
            view.addSubview(shape.shapeImage)
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                
                shape.shapeImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        
        var delay = 0.0
        for shape in instance!.setOfShapes {
            
            UIView.animate(withDuration: 0.5, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
                
                shape.pegImage.center = CGPoint(
                    x: shape.peggedCenterX,
                    y: shape.peggedCenterY //hard code for now
                )
                
                
            })
            delay += 0.5
        }
      // print("dock frame: \(dock.frame.minY)")
        instance!.isReady = true
    }
    
    //Handle Pan Function
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        
        //step into the function
        if let view = recognizer.view as? UIImageView {
            //print(view.center.y)
            
            /////////live translation in response to pan gesture/////
            let liveShape = instance!.grabShape(liveShape: view)
            view.center = CGPoint(
                x: liveShape.shapeImage.center.x + translation.x,
                y: liveShape.shapeImage.center.y + translation.y)
            
            recognizer.setTranslation(CGPoint(x:0,y:0), in: self.view)
            /////////End of live translation//////////////////////////
            
//////////////////////////////////////////////////////////////////////////////////////////////
//Preform action based on the liveShape location when tap is realeased
            
        if(recognizer.state.rawValue == 3) {
           
            //Option 1: shape is in dock range
            if (instance!.inRange(object: liveShape, target: instance!.dock)) {
                
                    backToDock(liveShape: liveShape)
                
            //Option 2: shape is in peg range
            } else if (instance!.inRange(object: liveShape, target: liveShape)) {
                
                //MATCH TO PEG MECH
                    toPeg(liveShape: liveShape)
                    liveShape.shapeImage.isUserInteractionEnabled = false
                //Tell the Game
                    instance!.numberOfShapesLeft = instance!.numberOfShapesLeft-1
                    instance!.score = instance!.score + 1
                    shapesLeft = shapesLeft-1   //
                    score.text = String(instance!.score)
                    //Play the sound
                    playSound()
                   //tempInHatAnim(shape: liveShape)
                
                //temp
                   // instance.updatePeggedCordsFromMovedImage(peg: liveShape.pegImage)
                
            //Option 3: not in range - translate back to dock
            } else {

                backToDock(liveShape: liveShape)
                
            }
        }

    }
        
}
    func newGame() {
        
        //this button is going to mock resetting the shapes and pegs
        
        //1 animate the three hats off screen
        //2 reset the shapesfull name list
        //3 randomly select three new shape names
        //4 update the pictures
        //5 translate pegs and hats back into their locations
        //6 update isUserInteractable so the shapes can move again.
        //7 translate the pegs back in
        
        // this procedure does not randomize the peg locations
        //I will come back to that when I've worked on the peg location stuff
        

        //1 animate the shapes off screen
        
    //    print(instance!.dock.peggedCenterY)
     //   print(dock.center.y)

        var delay = 0.0
        for shape in instance!.setOfShapes {
            
            UIView.animate(withDuration: 0.5, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
                shape.pegImage.center = CGPoint(
                    x: shape.pegImage.center.x-400,
                    y: self.dock.center.y - 400 //hard code for now
                )
            })
            delay += 0.5
        }
        
        //1.1 delay
      
    
        //2 reset the shapesfull name list
        shapeNames = fullShapeList
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() +  (0.5 * Double(amountOfShapes))) { // change 2 to desired number of seconds
            // Your code with delay
        
        
        //3 randomly select three new shape names
            self.instance!.newShapes()
        
      
            delay = 0.0
         for shape in self.instance!.setOfShapes {
             //4 update the pictures
            self.setImage(liveShape: shape)
            
            //5 translate pegs and hats back into their locations
            shape.shapeImage.center = CGPoint(
                x: shape.shelfedCenterX,
                y: shape.shelfedCenterY)
            
            
            
        
                UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    //Frame Option 1:
                    
                    shape.shapeImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                    
                })
                
            
             self.instance!.updatePeggedCordsFromMovedImage(peg: shape.pegImage)
            
           shape.pegImage.center = CGPoint(
            x: shape.peggedCenterX+400,
            y: shape.peggedCenterY
            )
            
            
            
           
            
            
            //6.1 generate new peg location
            let newPeg = self.randomGridCord()
            
            
             //7 animate the pegs back in
            UIView.animate(withDuration: 0.5, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
                shape.pegImage.center = CGPoint(
                    x: newPeg.0,
                    y: newPeg.1
                )
           
                
                //  self.aBlock.frame = CGRect(x: self.aBlock.frame.origin.x, y: 20, width: //self.aBlock.frame.width, height: self.aBlock.frame.height)
            })
            delay += 0.5
            
            self.instance!.updatePeggedCordsFromMovedImage(peg: shape.pegImage)
            //8 update isUserInteractable so the shapes can move again.
            shape.shapeImage.isUserInteractionEnabled = true
        }
        self.instance!.isReady = true
        }
        
     
    }
    
    
    @IBAction func pressedTest(_ sender: Any) {
        
        var conter = 0
        while(conter < 10000) {
            
       print(conter)
        for i in 1...amountOfShapes {
            
        let pegImage = UIImageView(image: nil)
        
        //hard coded width and height for now
        pegImage.frame = CGRect(x: 0, y: instance!.dock.shelfedCenterY, width: pegAspectRatio, height: pegAspectRatio )
        
        
        let pegCenter = randomGridCord()
        
        pegImage.center = CGPoint(
            x: pegCenter.0,
            y: pegCenter.1
        )
        
        }
             conter = conter + 1
        }
        
        print("10,000 attempts successful")
       
    }
    
    
    @IBAction func openSettings(_ sender: Any) {
        
        let secondVC:settingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsViewController") as! settingsViewController
        
            secondVC.modalPresentationStyle = .overCurrentContext
        
            // secondVC.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    
        
        secondVC.preferredContentSize = CGSize(width: 170, height: 130)
        self.present(secondVC, animated: true, completion: nil)
        
       
        //secondVC
        
        
    }
    
    func musicInit() {
        
        let path = Bundle.main.path(forResource: "bensound-ukulele", ofType: "mp3")
        let url  = NSURL(fileURLWithPath: path!)
        
        audioPlayer   = try! AVAudioPlayer(contentsOf: url as URL)
        audioPlayer.volume = 0.5
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
    
    func playSound() {
        
        if(sound == false) {
            return
        }
        
        let path = Bundle.main.path(forResource: "smoke", ofType: "wav")
        let url  = NSURL(fileURLWithPath: path!)
        
        placedSFX   = try! AVAudioPlayer(contentsOf: url as URL)
        placedSFX.prepareToPlay()
        placedSFX.numberOfLoops = 0
        placedSFX.volume = 1
        placedSFX.play()
    }
    
    func setImage(liveShape: shapeInfo) {
        //set shape
        let imageName = liveShape.name + ".png"
        let image = UIImage(named: imageName)
        liveShape.shapeImage.image = image
        
        //set peg
        let pegName = liveShape.name + "Hat.png"
        let pegImage = UIImage(named: pegName)
        liveShape.pegImage.image = pegImage
    }
    
    
} //end of vc


func toPeg(liveShape: shapeInfo) {
    
    UIView.animate(withDuration: 0.025, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
        //Frame Option 1:
        
        liveShape.shapeImage.center.x = liveShape.peggedCenterX
        liveShape.shapeImage.center.y = liveShape.peggedCenterY
        
        //  self.aBlock.frame = CGRect(x: self.aBlock.frame.origin.x, y: 20, width: //self.aBlock.frame.width, height: self.aBlock.frame.height)
    })
}

func tempInHatAnim(shape: shapeInfo) {
    
    let image = UIImage(named: "circleHatFull.png")
    shape.pegImage.image = image
    UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions.curveEaseIn, animations: {
        shape.shapeImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    })
    
}


func backToDock(liveShape: shapeInfo) {
    
    UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
        //Frame Option 1:
        
        liveShape.shapeImage.center.x = liveShape.shelfedCenterX
        liveShape.shapeImage.center.y = liveShape.shelfedCenterY
        
        //  self.aBlock.frame = CGRect(x: self.aBlock.frame.origin.x, y: 20, width: //self.aBlock.frame.width, height: self.aBlock.frame.height)
    })
    
}

//MARK: Delay func

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

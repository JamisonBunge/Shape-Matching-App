//
//  ViewController.swift
//  Shape Matching
//
//  Created by Jamison Bunge on 11/19/18.
//  Copyright © 2018 Jamison Bunge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dock: UIImageView!
    //NOTE
    // Chicago museam of art just made a bunch of images free to use
    // use these for the pictures that are being filled?
    
    
    //the real deal
    var s = 3
    
    
    lazy var instance = ModelGame(size: s, dockPassed: dock)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //real view didload
        
        constructView(numberOfShapes: s)
        
        
        //these need to be wrapped up
        //        let gestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //        let gestureRecognizer2 = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //        let gestureRecognizer3 = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //
        //Hardcoded Tags
        //        imageSquare.tag = ShapeTag.Square.rawValue
        //        imageStar.tag = ShapeTag.Star.rawValue
        //        imageTriangle.tag = ShapeTag.Triangle.rawValue
        
        //        imageSquare.tag = 1
        //        imageStar.tag = 2
        //        imageTriangle.tag = 3
        dock.tag = 5
        
        instance.touch()    //init the game
        
        for object in instance.setOfShapes {
            setImage(liveShape: object)
        }
        
        
        //constructView(numberOfShapes: 3) //hard code the three still
        //print(ShapeTag.Star.rawValue)
        
        //var someShape : shapeInfo
        
        // someShape.name = String(ShapeTag.Square)
        //Init the Class
        
        //let ari : UIImageView? = nil
        
        
        //Add Gestures
        //        imageStar.isUserInteractionEnabled = true
        //        imageStar.addGestureRecognizer(gestureRecognizer1)
        //
        //        imageTriangle.isUserInteractionEnabled = true
        //        imageTriangle.addGestureRecognizer(gestureRecognizer2)
        //
        //        imageSquare.isUserInteractionEnabled = true
        //        imageSquare.addGestureRecognizer(gestureRecognizer3)
        
    }
    
    func setImage(liveShape: shapeInfo) {
        //set shape
        let imageName = liveShape.name + ".png"
        print(imageName)
        let image = UIImage(named: imageName)
        liveShape.shapeImage.image = image
        
        //set peg
        let pegName = liveShape.name + ".png"
        print(pegName)
        let pegImage = UIImage(named: pegName)
        liveShape.pegImage.image = pegImage
        
        
    }
    
    
    func constructView(numberOfShapes: Int) {
        
        //hard code get positions for now
        var positionsFromShelfCords : [CGFloat] = []
        let incrementLength = dock.frame.width / 3
        positionsFromShelfCords.append(dock.center.x - incrementLength)
        positionsFromShelfCords.append(dock.center.x)
        positionsFromShelfCords.append(dock.center.x + incrementLength)
        
        for i in 0..<numberOfShapes {
            
            
            //createImage
            let shapeImage = UIImageView(image: nil)
            
            //hard coded width and height for now
            shapeImage.frame = CGRect(x: 0, y: instance.dock.shelfedCenterY, width: 75, height: 75)
            view.addSubview(shapeImage)
            
            shapeImage.center = CGPoint(
                x: positionsFromShelfCords[i],
                y: dock.center.y
            )
            
            let pegImage = UIImageView(image: nil)
            
            //hard coded width and height for now
            pegImage.frame = CGRect(x: 0, y: instance.dock.shelfedCenterY, width: 75, height: 75)
            view.addSubview(pegImage)
            
            pegImage.center = CGPoint(
                x: positionsFromShelfCords[i],
                y: dock.center.y - 400 //hard code for now
            )
            
            
            //set UI Properties
            shapeImage.isUserInteractionEnabled = true
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            shapeImage.addGestureRecognizer(gestureRecognizer)
            
            //put it in the model
            instance.addShape(shape: shapeImage, peg: pegImage)
            print(i)
            
            
            
            
            
        }
        
        
        
        //things in this function will be hardcoded for now.
        //specfically the shape types and the size of the frames
        
        //the centers however will be calculated relitive to the shelf
        
        //I am not sure how i am handling the shelf yet, I either can
        //A] keep it in the storyboard
        //B] make it programmatically too
        
        //        let tempNameArray : [String:Int] = ["square.png" : 0 ,"star.png" : 1 ,"triangle.png" : 2 ]
        //        let imageTags = [1,2,3]
        //
        //
        //        //get shelf spots
        //            //hard coding this for three spots
        //
        //
        //
        //        for coord in positionsFromShelfCords {
        //           // print(coord)
        //        }
        //
        //
        //        for (name,i) in tempNameArray {
        //
        //            let imageName = name
        //            let image = UIImage(named: imageName)
        //            let imageView = UIImageView(image: image!)
        //            shapeImages.append(imageView)
        //
        //             let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //            imageView.addGestureRecognizer(gestureRecognizer)
        //
        //            imageView.tag = i + 1
        //            imageView.isUserInteractionEnabled = true
        //
        //
        //
        //
        //          //  print(positionsFromShelfCords[i])
        //
        //            imageView.frame = CGRect(x: 0, y: dock.center.y, width: 75, height: 75)
        //            view.addSubview(imageView)
        //
        //            imageView.center = CGPoint(
        //                x: positionsFromShelfCords[i],
        //                y: dock.center.y
        //            )
        //
        //        }
        //
        
        
        
        
        
    }
    
    
    
    
    //Handle Pan Function
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        
        if let view = recognizer.view as? UIImageView {
            
            let liveShape = instance.grabShape(liveShape: view)
            
            // print ("I am a image view")
            
            //view.frame = CGRect(x: 0, y: 0, width: 100, height: 100 )
            
            view.center = CGPoint(
                x: liveShape.shapeImage.center.x + translation.x,
                y: liveShape.shapeImage.center.y + translation.y
            )
            
            recognizer.setTranslation(CGPoint(x:0,y:0), in: self.view)
            
            //   print("x-cords: \(view.frame.maxX),\(view.frame.minX)")
            //      print("y-cords: \(view.frame.maxY),\(view.frame.minY)")
            //  print("y-cords: \(view.center.x),\(view.center.y)")
            
            // let defaultInfo = instance.grabShapeInfo(tag: view.tag)
            let dockInfo = instance.dock
            
            // print("y-cords: min: \(dockInfo.shelfedMinY) ,center y: \(view.center.y),max \(dockInfo.yMax)")
            //print("x-cords: min: \(dockInfo.xMin),center x: \(view.center.x), max \(dockInfo.xMax)")
            //      print()
            
            if (((liveShape.shapeImage.center.x  > dockInfo.shelfedMinX) && (liveShape.shapeImage.center.x  < dockInfo.shelfedMaxX))
                && ((liveShape.shapeImage.center.y > dockInfo.shelfedMinY) && (liveShape.shapeImage.center.y < dockInfo.shelfedMaxY))) {
                
                //Object is in range
                // print("yo")
                
                if recognizer.state.rawValue == 3 { // 3 corresponds to letting go of the tap
                    //  print("HI")
                    view.center = CGPoint(
                        x: liveShape.shelfedCenterX,
                        y: liveShape.shelfedCenterY
                    )
                    
                    recognizer.setTranslation(CGPoint(x:0,y:0), in: self.view)
                    
                }
                
            } else {
                // print("out")
            }
            
            
        }
        
        
        
        
    }
}

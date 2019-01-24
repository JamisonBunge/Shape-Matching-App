//
//  Model.swift
//
//
//  Created by Jamison Bunge on 11/28/18.
//

import Foundation
import UIKit

class ModelGame {
    
    
    //how do i want to store the shapes?
    //array of shape struct?
    
    //var imagesArray : [UIImageView]
    var setOfShapes : [shapeInfo] = []
    //var music = true
    var sound : Bool
    let dock : shapeInfo
    let size : Int
    var isReady : Bool
    var numberOfShapesLeft : Int {
        didSet {
            if numberOfShapesLeft == 0 {
                print("newGame")
                numberOfShapesLeft = size
                //this new game isnt even used really, come back and evaluate this 
                }
            }

    }
    
    var score : Int
    //    var squareInShapeInfo: shapeInfo
    //    var starInShapeInfo: shapeInfo
    //    var triangleInShapeInfo: shapeInfo
    
    
    func touch() {
        //do nothing
    }
    
    func newShapes() {
        
        for i in 0..<setOfShapes.count {
            setOfShapes[i].newName()
        }
    }
    
    func grabShape(liveShape: UIImageView) -> shapeInfo {
        
        if let i = setOfShapes.index(where: { $0.shapeImage == liveShape }) {
            //   print("hidden name: \(setOfShapes[i].name),tag: \(setOfShapes[i].shapeImage.tag) ")
            //    print("the tag is \(setOfShapes[i].shapeImage.tag) and i is \(i)")
            // print(setOfShapes[i].name)
            return setOfShapes[i]
        }
        //temp defualt return
        return dock
        
    }
    
    
    //    func grabShapeInfoFromName(name: string ) -> shapeInfo {
    //    }
    func grabShapeInfo(name: String ) -> shapeInfo {
        
        let info : shapeInfo = dock
        
        if let i = setOfShapes.index(where: { $0.name == name }) {
            //   print("hidden name: \(setOfShapes[i].name),tag: \(setOfShapes[i].shapeImage.tag) ")
            //    print("the tag is \(setOfShapes[i].shapeImage.tag) and i is \(i)")
            print(setOfShapes[i].name)
            return setOfShapes[i]
        }
        return info
    }
    
    
    //this guy is supposed to be what the new init will turn into when the old way is refactored to support the shape struct
    func startGame(numberOfShapes: Int) {
        
        //in this function i want to randomly select 3 shapes from the string array
        //that array needs to get smaller when an option is popped
        //not worrying about the PEG stuff right now, just pass the shape for both
        
        //based on the shape that i need to select an image and such
        
        // let setOfShapes : [shapeInfo]
        //create 3 shapes
        //create 3 pegs
        //
        
        
    }
    func updatePeggedCordsFromMovedImage(peg: UIImageView) {
        
        if let i = setOfShapes.index(where: { $0.pegImage == peg }) {
            setOfShapes[i].peggedCenterX = peg.center.x
            setOfShapes[i].peggedCenterY = peg.center.y
            setOfShapes[i].peggedMinX = peg.frame.minX
            setOfShapes[i].peggedMaxX = peg.frame.maxX
            setOfShapes[i].peggedMinY = peg.frame.minY
            setOfShapes[i].peggedMaxY = peg.frame.maxY
        }
        
    }
    
    
    func addShape(shape: UIImageView, peg: UIImageView) {
        setOfShapes.append(shapeInfo.init(shape: shape, peg: peg))
    }
    
    
    init(size: Int, dockPassed: UIImageView) {

        dock = shapeInfo.init(shape: dockPassed, peg: dockPassed)
        self.size = size
        numberOfShapesLeft = size
        score = 0
        isReady = false
        sound = true
    }
    
    func newGame() {
        
    }
    
    func newGame(size: Int) {
        
    }
    
  
    
    
    func inRange(object: shapeInfo, target: shapeInfo) -> Bool {
    
        if (((object.shapeImage.center.x  > target.peggedMinX) && (object.shapeImage.center.x  < target.peggedMaxX))
            && ((object.shapeImage.center.y > target.peggedMinY) && (object.shapeImage.center.y < target.peggedMaxY))) {
                return true
        } else {
              return false
        }
    }
}




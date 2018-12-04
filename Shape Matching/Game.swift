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
    let dock : shapeInfo
    
    //    var squareInShapeInfo: shapeInfo
    //    var starInShapeInfo: shapeInfo
    //    var triangleInShapeInfo: shapeInfo
    
    
    func touch() {
        //do nothing
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
        
        var info : shapeInfo = dock
        
        //            if tag == 1 {
        //                //sqaure
        //                info = squareInShapeInfo
        //            } else if tag == 2{
        //                //star case
        //                info = starInShapeInfo
        //            } else if tag == 3 {
        //                //trianlge case
        //                info = triangleInShapeInfo
        //            } else if tag == 5 {
        //                info = DockInShapeInfo
        //            } else {
        //                info = DockInShapeInfo
        //            }
        //        print("count of array:\(setOfShapes.count)")
        //
        //
        //        for object in setOfShapes {
        //            if object.shapeImage.tag == tag {
        //                print("does this ever happen")
        //                return object
        //        }
        //        }
        //        print("this should never happen: \(tag)")
        //         return info
        
        //TO DO
        //instead of looping, use lindex(where: to grab the shape you want
        
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
    
    func addShape(shape: UIImageView, peg: UIImageView) {
        setOfShapes.append(shapeInfo.init(shape: shape, peg: peg))
        
    }
    
    init(size: Int, dockPassed: UIImageView) {
        
        //for now, hardcode the three shapes
        
        //        squareInShapeInfo = shapeInfo.init(shape: squarePassed, peg: squarePassed)
        //        starInShapeInfo = shapeInfo.init(shape: starPassed, peg: starPassed)
        //        triangleInShapeInfo = shapeInfo.init(shape: trianglePassed, peg: trianglePassed)
        dock = shapeInfo.init(shape: dockPassed, peg: dockPassed)
        
        //        setOfShapes.append(squareInShapeInfo)
        //        setOfShapes.append(starInShapeInfo)
        //        setOfShapes.append(triangleInShapeInfo)
        //
        
    }
    
}










//    let defaultsSquare : (xMin: CGFloat, xMax: CGFloat,
//    yMin: CGFloat, yMax: CGFloat, xCenter: CGFloat, yCenter: CGFloat)
//    let defaultsStar : (xMin: CGFloat, xMax: CGFloat,
//    yMin: CGFloat, yMax: CGFloat, xCenter: CGFloat, yCenter: CGFloat)
//    let defaultsTriangle : (xMin: CGFloat, xMax: CGFloat,
//    yMin: CGFloat, yMax: CGFloat, xCenter: CGFloat, yCenter: CGFloat)
//
//    let defaultsDock : (xMin: CGFloat, xMax: CGFloat,
//    yMin: CGFloat, yMax: CGFloat, xCenter: CGFloat, yCenter: CGFloat)







//    func getDefaultInformation(tag: Int ) -> (xMin: CGFloat, xMax: CGFloat,
//        yMin: CGFloat, yMax: CGFloat, xCenter: CGFloat, yCenter: CGFloat) {
//
//        var info : (xMin: CGFloat, xMax: CGFloat,
//        yMin: CGFloat, yMax: CGFloat, xCenter: CGFloat, yCenter: CGFloat)
//
////        if tag == 1 {
////            //sqaure
////            info = defaultsSquare
////        } else if tag == 2{
////            //star case
////            info = defaultsStar
////        } else if tag == 3 {
////            //trianlge case
////            info = defaultsTriangle
////        } else if tag == 4 {
////            info = defaultsDock
////        } else {
////            info = defaultsDock
////            }
//        return info
//    }
//

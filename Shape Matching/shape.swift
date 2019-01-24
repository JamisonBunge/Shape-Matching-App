//
//  shape.swift
//
//
//  Created by Jamison Bunge on 11/28/18.
//
import UIKit
import Foundation

let fullShapeList = ["square","circle","pentagon","square","circle","pentagon","heart"]

var shapeNames = fullShapeList
var count = 1

enum ShapeTag : Int {
    case Square = 1
    case Star = 2
    case Triangle = 3
}

struct shapeInfo {
    
    // 'on-the-shelf' coords
    let shelfedMinX : CGFloat
    let shelfedMaxX : CGFloat
    
    let shelfedMinY : CGFloat
    let shelfedMaxY : CGFloat
    
    let shelfedCenterX : CGFloat
    let shelfedCenterY : CGFloat
    
    // 'in-the-peg' coords
    var peggedMinX : CGFloat
    var peggedMaxX : CGFloat
    
    var peggedMinY : CGFloat
    var peggedMaxY : CGFloat
    
    var peggedCenterX : CGFloat
    var peggedCenterY : CGFloat
    
    //live photo
    var shapeImage : UIImageView
    var pegImage : UIImageView
    
    // shape info
    var name : String = ""
    // var tag : Int = 0
    var isDock : Bool = false
    
    
    
    
    init(shape: UIImageView, peg: UIImageView) {
        
        //set shelfed coords
        shelfedMinX = shape.frame.minX
        shelfedMaxX = shape.frame.maxX
        
        shelfedMinY = shape.frame.minY
        shelfedMaxY = shape.frame.maxY
        
        shelfedCenterX = shape.center.x
        shelfedCenterY = shape.center.y
        
        //set pegged coords
        peggedMinX = peg.frame.minX
        peggedMaxX = peg.frame.maxX
        
        peggedMinY = peg.frame.minY
        peggedMaxY = peg.frame.maxY
        
        peggedCenterX = peg.center.x
        peggedCenterY = peg.center.y
        
        //link images
        shapeImage = shape
        pegImage = peg
        
        if(shape.tag==5) {
            isDock = true
        }
        
        // set shape info
        name = selectRandomShape()
        // tag = 0
    
        
    }
    
    mutating func newName() {
         self.name = selectRandomShape()
    }

    
    func selectRandomShape() -> String
    {
        if(isDock) {
            return "dock"
        } else {
            var name : String
            count = count + 1
            let randomIndex = Int(arc4random_uniform(UInt32(shapeNames.count)))
            name = shapeNames[randomIndex]
            shapeNames.remove(at: randomIndex)
            return name
        }
    }
}

func resetShapes() {
    shapeNames = fullShapeList
}


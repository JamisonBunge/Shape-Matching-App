//
//  shape.swift
//
//
//  Created by Jamison Bunge on 11/28/18.
//
import UIKit
import Foundation

let fullShapeList = ["square","star","triangle","circle","rhombus","hexicon"]
var shapeNames = fullShapeList

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
    let peggedMinX : CGFloat
    let peggeddMaxX : CGFloat
    
    let peggedMinY : CGFloat
    let peggedMaxY : CGFloat
    
    let peggedCenterX : CGFloat
    let peggedCenterY : CGFloat
    
    //live photo
    let shapeImage : UIImageView
    let pegImage : UIImageView
    
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
        peggeddMaxX = peg.frame.minX
        
        peggedMinY = peg.frame.minX
        peggedMaxY = peg.frame.minX
        
        peggedCenterX = peg.frame.minX
        peggedCenterY = peg.frame.minX
        
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
    
    func selectRandomShape() -> String
    {
        if(isDock) {
            return "dock"
        } else {
            
            var name : String
            
            let randomIndex = Int(arc4random_uniform(UInt32(shapeNames.count)))
            name = shapeNames[randomIndex]
            print(shapeNames[randomIndex])
            shapeNames.remove(at: randomIndex)
            
            return name
        }
        
        // return "dock"
        
    }
    
}



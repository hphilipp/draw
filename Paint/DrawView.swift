//
//  DrawView.swift
//  Paint
//
//  Created by Thomas Monninger on 10.04.17.
//  Copyright © 2017 Philipp. All rights reserved.
//

import UIKit

class DrawView : UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var pathList : [UIBezierPath] = []
    var startPoint: CGPoint!
    var draw : Bool!
 
    
    override func touchesBegan(_ touches: Set<UITouch>,
                      with event: UIEvent?)
    {
        if let touch = touches.first as UITouch? {
            startPoint = touch.location(in: self)
            draw = true
        }
        
        
        /*
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        
        let image = renderer.image { ctx in
            
        }
 */
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?)
    {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            print(pathList.count)
            
            let endPoint = touch.location(in: self)
            let newPath = UIBezierPath()
            newPath.lineWidth = 3
            newPath.move(to: startPoint)
            newPath.addLine(to: endPoint)
            if pathList.count > 0 && !draw {
                pathList.removeLast()
                draw = false
            }
            pathList.append(newPath)
            setNeedsDisplay()
        }
    }


    
    override func draw(_ rect: CGRect) {
        /*
        var path = UIBezierPath(ovalIn: rect)
        UIColor.green.setFill()
        path.fill()
        //set up the width and height variables
        //for the horizontal stroke
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        //create the path
        var plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = plusHeight
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
            x:bounds.width/2 - plusWidth/2,
            y:bounds.height/2))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2 + plusWidth/2,
            y:bounds.height/2))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2,
            y:bounds.height/4))
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2 - plusWidth/2,
            y:bounds.height/2))
        
        //set the stroke color
        UIColor.white.setStroke()
        
        //draw the stroke
        pathList.append(plusPath)
 */
        UIColor.green.setFill()
        
        for path in pathList {
            path.fill()
            path.stroke()
        }
        
    }
}

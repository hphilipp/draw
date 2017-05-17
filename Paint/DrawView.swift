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
    var actualPath: UIBezierPath!
    var actualPathNumber = 0
    var colorList : [UIColor] = []
    var roundedEdges = true
    var redoPathList : [UIBezierPath] = []
    var redoColorList : [UIColor] = []
    var lastRemovedColor: UIColor!
    enum lineStyle {
        case linear
        case freeHand
        //case polygon
    }
    var style = lineStyle.freeHand
    var color = UIColor.black
    var lineWidth : CGFloat = 3.0
 
    
    func setLineStyle(setting : lineStyle)
    {
        style = setting
    }
    
    func setRoundedEdges(edges: Bool)
    {
        self.roundedEdges = edges
    }
    
    func setColor(color : UIColor)
    {
        self.color = color
    }
    
    func setBackgroundColor(color : UIColor)
    {
        self.backgroundColor = color
    }
    
    func setLineWidth(width: Float)
    {
        self.lineWidth = CGFloat(width)
    }
    
    func resetDrawing()
    {
        self.backgroundColor = UIColor.white;
        pathList.removeAll()
        colorList.removeAll()
        redoPathList.removeAll()
        redoColorList.removeAll()
        actualPathNumber = 0
        setNeedsDisplay()
    }
    
    func undoPath()
    {
        if actualPathNumber > 0 {
            redoPathList.append(pathList.removeLast())
            redoColorList.append(colorList.removeLast())
            actualPathNumber = actualPathNumber - 1
            setNeedsDisplay()
        }
        else {
            Toast.showMessage(message: "Undo nicht möglich")
        }
    }
    
    func redoPath()
    {
        if redoPathList.count > 0 {
            pathList.append(redoPathList.removeLast())
            colorList.append(redoColorList.removeLast())
            actualPathNumber = actualPathNumber + 1
            setNeedsDisplay()
        }
        else {
            Toast.showMessage(message: "Redo nicht möglich")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                      with event: UIEvent?)
    {
        if let touch = touches.first as UITouch? {
            startPoint = touch.location(in: self)
            
            actualPath = UIBezierPath()
            actualPath.lineWidth = lineWidth
            actualPath.move(to: startPoint)
            pathList.append(actualPath)
            colorList.append(color)
            if roundedEdges {
                actualPath.lineJoinStyle = .round
                actualPath.lineCapStyle = .round
            }
            else
            {
                actualPath.lineJoinStyle = .miter
                actualPath.lineCapStyle = .square
            }
        }
        
        
        /*
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        
        let image = renderer.image { ctx in
            
        }
        */
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        actualPathNumber = actualPathNumber + 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch style {
            case lineStyle.linear:
                if let touch = touches.first as UITouch? {
                    let endPoint = touch.location(in: self)
                    
                    pathList[actualPathNumber] = { () -> UIBezierPath in
                        let tempPath = UIBezierPath()
                        tempPath.lineWidth = lineWidth
                        tempPath.move(to: startPoint)
                        tempPath.addLine(to: endPoint)
                        return tempPath
                    }()
                    
                    setNeedsDisplay()
                }
            case lineStyle.freeHand:
                if let touch = touches.first as UITouch? {
                    let endPoint = touch.location(in: self)
                    
                    actualPath.addLine(to: endPoint)
                    setNeedsDisplay()
                }
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
        
        for i in 0 ..< pathList.count {
            colorList[i].setStroke()
            pathList[i].stroke()
        }
    }
}

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

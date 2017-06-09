//
//  DrawView.swift
//  Paint
//
//  Created by Thomas Monninger on 10.04.17.
//  Copyright © 2017 Philipp. All rights reserved.
//

import UIKit

class DrawView : UIView {
    
    var pathList : [UIBezierPath] = []
    var startPoint: CGPoint!
    var actualPath: UIBezierPath!
    var actualPathNumber = 0 //actually you could also use the last path in pathlist (then you would not have to handle this variable)
    var colorList : [UIColor] = []
    var roundedEdges = true
    var redoPathList : [UIBezierPath] = []
    var redoColorList : [UIColor] = []
    var lastRemovedColor: UIColor!
    enum lineStyle {
        case linear
        case freeHand
        case eraser
        //case polygon
    }
    var style = lineStyle.freeHand
    var color = UIColor.blue
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
    
    func resetDrawing(clearBackground: Bool)
    {
        if clearBackground {
            self.backgroundColor = UIColor.white
        }
        
        pathList.removeAll()
        colorList.removeAll()
        redoPathList.removeAll()
        redoColorList.removeAll()
        actualPathNumber = 0
        setNeedsDisplay()
    }
    
    func undoPath()
    {
        redoPathList.append(pathList.removeLast())
        redoColorList.append(colorList.removeLast())
        actualPathNumber = actualPathNumber - 1
        setNeedsDisplay()
    }
    
    func redoPath()
    {
        pathList.append(redoPathList.removeLast())
        colorList.append(redoColorList.removeLast())
        actualPathNumber = actualPathNumber + 1
        setNeedsDisplay()
    }
    
    // func that is called when you touch the screen
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?)
    {
        if let touch = touches.first as UITouch? {
            //create new path with all chracteristics and append it to the pathlist
            //set the startposition to the position of the touch
            
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        actualPathNumber = actualPathNumber + 1
    }
    
    // func that handles the different line styles
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch style {
            // redraw a new line from starting point to the position of the touch
        // path always consists of only two points
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
            // add the position of the touch to the path as a new point
        // path can consist of many points
        case lineStyle.freeHand:
            // same as eraser (differentiation is used for different purpose)
            fallthrough
        case lineStyle.eraser:
            if let touch = touches.first as UITouch? {
                let endPoint = touch.location(in: self)
                
                actualPath.addLine(to: endPoint)
                setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        // go through all paths and display them with their belonging color
        for i in 0 ..< pathList.count {
            colorList[i].setStroke()
            pathList[i].stroke()
        }
    }
}

extension UIView {
    
    // generates an UIImage out of the content in drawView
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

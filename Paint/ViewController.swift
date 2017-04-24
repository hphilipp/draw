//
//  ViewController.swift
//  Paint
//
//  Created by Philipp on 10.04.17.
//  Copyright © 2017 Philipp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //TODO:
    //save pen and color in Class and change button tint to saved color
    
    @IBOutlet var drawView: DrawView!
    @IBOutlet var colorBtn: UIBarButtonItem!
    @IBOutlet var penBtn: UIBarButtonItem!
    @IBOutlet var widthButton: UIBarButtonItem!
    
    @IBAction func resetDrawing(_ sender: UIBarButtonItem) {
        drawView.resetDrawing()
    }
    
    @IBAction func Redo(_ sender: Any) {
        drawView.redoPath()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        let img = drawView.asImage()
        
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    @IBAction func EraserClicked(_ sender: UIBarButtonItem){
        
        //TODO: Use Background Color
        drawView.color = UIColor.white
    }
    
    @IBAction func PenClicked(_ sender: UIBarButtonItem) {
        let popup = UIAlertController(title: "Stiftauswahl", message: "Wählen sie die gewünschte Stiftart", preferredStyle: .actionSheet)
        
        let back = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        
        //Todo:
        //Handle saving the new pen and thickness
        let linear = UIAlertAction(title: "Geraden", style: .default) { (action) in
            self.drawView.setLineStyle(setting: .linear)
            self.penBtn.image = #imageLiteral(resourceName: "Ruler")
            self.drawView.color = self.colorBtn.tintColor!
        }
        let free = UIAlertAction(title: "Freihand", style: .default) { (action) in
            self.drawView.setLineStyle(setting: .freeHand)
            self.penBtn.image = #imageLiteral(resourceName: "Brush")
            self.drawView.color = self.colorBtn.tintColor!
        }
        
        
        popup.addAction(linear)
        popup.addAction(free)
        popup.addAction(back)
        
        present(popup, animated: true)
    }
    
    @IBAction func ChangeLineWidth(_ sender: UIBarButtonItem) {
        
        //get the Slider values from UserDefaults
        let defaultSliderValue : Float = Float(self.drawView.lineWidth)
        
        //create the Alert message with extra return spaces
        let sliderAlert = UIAlertController(title: "Strichstärke", message: "Hier können Sie die Strichstärke einstellen\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        //create a Slider and fit within the extra message spaces
        //add the Slider to a Subview of the sliderAlert
        let slider = UISlider(frame:CGRect(x: 10, y: 100, width: 250, height: 80))
        slider.minimumValue = 1
        slider.maximumValue = 40
        slider.value = defaultSliderValue
        slider.isContinuous = true
        slider.tintColor = self.drawView.color
        sliderAlert.view.addSubview(slider)
        
        //OK button action
        let sliderAction = UIAlertAction(title: "Ok", style: .default, handler: { (result : UIAlertAction) -> Void in
            self.drawView.setLineWidth(width: slider.value)
        })
        
        //Cancel button action
        let back = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        
        //Add buttons to sliderAlert
        sliderAlert.addAction(sliderAction)
        sliderAlert.addAction(back)
        
        //present the sliderAlert message
        self.present(sliderAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func ColorClicked(_ sender: UIBarButtonItem) {
        let popup = UIAlertController(title: "Farbauswahl", message: "Wählen sie die gewünschte Farbe\n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        //credits to johankasperi
        let colorPicker = SwiftHSVColorPicker(frame: CGRect(x: 0, y: 80, width: 300, height: 220))
        popup.view.addSubview(colorPicker)
        
        colorPicker.setViewColor(UIColor.red)
        
        let back = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        
        //OK button action
        let setColor = UIAlertAction(title: "Ok", style: .default, handler: { (result : UIAlertAction) -> Void in
            self.colorBtn.tintColor = colorPicker.color
            self.drawView.color = colorPicker.color
        })
        
        popup.addAction(setColor)
        popup.addAction(back)
        
        present(popup, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        colorBtn.tintColor = drawView.color
    }
}


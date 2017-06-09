//
//  ViewController.swift
//  Paint
//
//  Created by Philipp on 10.04.17.
//  Copyright © 2017 Philipp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet var drawView: DrawView!
    @IBOutlet var colorBtn: UIBarButtonItem!
    @IBOutlet var penBtn: UIBarButtonItem!
    @IBOutlet var widthButton: UIBarButtonItem!
    
    @IBAction func resetDrawing(_ sender: UIBarButtonItem) {
        if drawView.pathList.count > 0 || drawView.backgroundColor != UIColor.white {
            let popup = UIAlertController(title: "Bild löschen", message: "Möchten Sie wirklich das Gezeichnete samt Hintergrund löschen?", preferredStyle: .alert)
            
            let back = UIAlertAction(title: "Nein", style: .cancel, handler: nil)
            
            let delete = UIAlertAction(title: "Ja", style: .destructive) { (action) in
                self.drawView.resetDrawing(clearBackground: true)
                if(self.drawView.style == .eraser)
                {
                    self.drawView.color = self.drawView.backgroundColor!
                }
            }
            
            popup.addAction(delete)
            popup.addAction(back)
            
            present(popup, animated: true)
        }
        else{
            Toast.showMessage(message: "Leeres Bild kann nicht gelöscht werden")
        }
    }
    
    @IBAction func Redo(_ sender: UIBarButtonItem) {
        if drawView.redoPathList.count > 0 {
            drawView.redoPath()
        }
        else {
            Toast.showMessage(message: "Redo nicht möglich")
        }
    }
    @IBAction func Undo(_ sender: UIBarButtonItem) {
        if drawView.actualPathNumber > 0 {
            drawView.undoPath()
        }
        else {
            Toast.showMessage(message: "Undo nicht möglich")
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if drawView.pathList.count > 0 {
            let popup = UIAlertController(title: "Bild speichern", message: "Möchten Sie das Bild ins Fotoalbum speichern?", preferredStyle: .alert)
            
            let back = UIAlertAction(title: "Nein", style: .cancel, handler: nil)
            
            let delete = UIAlertAction(title: "Ja", style: .default) { (action) in
                let img = self.drawView.asImage()
                
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
                Toast.showMessage(message: "Bild gespeichert")
            }
            
            popup.addAction(delete)
            popup.addAction(back)
            
            present(popup, animated: true)
        }
        else {
            Toast.showMessage(message: "Kein Bild vorhanden")
        }
    }
    
    @IBAction func load(_ sender: UIBarButtonItem) {
        if drawView.pathList.count > 0 {
            let popup = UIAlertController(title: "Galerie", message: "Möchten Sie ein Bild aus dem Fotoalbum als Hintergrund auswählen?\n Dabei wird das Gezeichnete gelöscht.", preferredStyle: .alert)
            
            let back = UIAlertAction(title: "Nein", style: .cancel, handler: nil)
            
            let delete = UIAlertAction(title: "Ja", style: .destructive) { (action) in
                self.openGallery()
            }
            
            popup.addAction(delete)
            popup.addAction(back)
            
            present(popup, animated: true)
        }
        else {
            openGallery()
        }
    }
    
    // open the fotogallery to choose a photo
    func openGallery() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            Toast.showMessage(message: "Keine Galerie vorhanden")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func camera(_ sender: UIBarButtonItem) {
        if drawView.pathList.count > 0 {
            let popup = UIAlertController(title: "Kamera", message: "Möchten Sie mit der Kamera einen Hintergrund aufnehmen?\n Dabei wird das Gezeichnete gelöscht.", preferredStyle: .alert)
            
            let back = UIAlertAction(title: "Nein", style: .cancel, handler: nil)
            
            let delete = UIAlertAction(title: "Ja", style: .destructive) { (action) in
                self.openCamera()
            }
            
            popup.addAction(delete)
            popup.addAction(back)
            
            present(popup, animated: true)
        }
        else {
            openCamera()
        }
    }
    
    // open the camera to take a photo and use it as the background
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            Toast.showMessage(message: "Keine Kamera vorhanden")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.cameraCaptureMode = .photo
        imagePicker.modalPresentationStyle = .fullScreen
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // if a color was picked, resize it and set it as the background
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let resizedImage = imageResize(image: chosenImage, size: CGSize(width: drawView.frame.width, height: drawView.frame.height))
        drawView.setBackgroundColor(color: UIColor(patternImage: resizedImage))
        dismiss(animated:true, completion: nil)
        
        drawView.resetDrawing(clearBackground: false)
        if drawView.style == .eraser {
            self.drawView.color = self.drawView.backgroundColor!
        }
    }
    
    // resizes the image to fit the width of the device screen. Otherwise it would only be a small part of the picture.
    func imageResize(image: UIImage, size:CGSize) -> UIImage
    {
        var scaledImageRect = CGRect.zero;
        
        let aspectWidth:CGFloat = size.width / image.size.width;
        let aspectHeight:CGFloat = size.height / image.size.height;
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight);
        
        scaledImageRect.size.width = image.size.width * aspectRatio;
        scaledImageRect.size.height = image.size.height * aspectRatio;
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        
        image.draw(in: scaledImageRect);
        
        let scaledImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return scaledImage;
    }
    
    @IBAction func PenClicked(_ sender: UIBarButtonItem) {
        let popup = UIAlertController(title: "Stiftauswahl", message: "Wählen Sie die gewünschte Stiftart", preferredStyle: .actionSheet)
        
        let back = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        
        let linear = UIAlertAction(title: "Lineal", style: .default) { (action) in
            self.drawView.setLineStyle(setting: .linear)
            self.penBtn.image = #imageLiteral(resourceName: "Ruler")
            self.drawView.color = self.colorBtn.tintColor!
            self.colorBtn.isEnabled = true
        }
        let free = UIAlertAction(title: "Freihand", style: .default) { (action) in
            self.drawView.setLineStyle(setting: .freeHand)
            self.penBtn.image = #imageLiteral(resourceName: "Brush")
            self.drawView.color = self.colorBtn.tintColor!
            self.colorBtn.isEnabled = true
        }
        let eraser = UIAlertAction(title: "Radiergummi", style: .default) { (action) in
            self.drawView.setLineStyle(setting: .eraser)
            self.penBtn.image = #imageLiteral(resourceName: "Eraser")
            self.drawView.color = self.drawView.backgroundColor!
            self.colorBtn.isEnabled = false
        }
        
        
        popup.addAction(linear)
        popup.addAction(free)
        popup.addAction(eraser)
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
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: 100, width: sliderAlert.view.bounds.size.width - margin * 4.0, height: 80)
        let slider = UISlider(frame: rect)
        slider.minimumValue = 1
        slider.maximumValue = 40
        slider.value = defaultSliderValue
        slider.isContinuous = true
        if drawView.style == .eraser {
            slider.tintColor = UIColor.white
        }
        else {
            slider.tintColor = self.drawView.color
        }
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
        let popup = UIAlertController(title: "Farbauswahl", message: "Wählen Sie die gewünschte Farbe\n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        //credits for colorpicer to johankasperi
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: 80, width: popup.view.bounds.size.width - margin * 4.0, height: 220)
        let colorPicker = SwiftHSVColorPicker(frame: rect)
        
        popup.view.addSubview(colorPicker)
        
        colorPicker.setViewColor(drawView.color)
        
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
    
    // set the delegate of the settingsViewController to this viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check if the segue destination is the settingsViewController
        if let settings = segue.destination as? SettingsViewController{
            settings.delegate = self
        }
    }
}

extension ViewController : SettingsViewControllerDelegate {
    
    // implementation of the delegate functions
    func didSelectColor(color: UIColor) {
        drawView.setBackgroundColor(color: color)
        
        drawView.resetDrawing(clearBackground: false)
        if drawView.style == .eraser {
            self.drawView.color = self.drawView.backgroundColor!
        }
    }
    
    func didClearForeground(clearBackground: Bool) {
        drawView.resetDrawing(clearBackground: clearBackground)
    }
}

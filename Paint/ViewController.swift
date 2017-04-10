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
    
    @IBOutlet var colorBtn: UIBarButtonItem!
    @IBOutlet var penBtn: UIBarButtonItem!
    
    var color = UIColor.black
    
    @IBAction func resetDrawing(_ sender: UIBarButtonItem) {
        //TODO:
        //Implement reset drawing
    
    }
    
    @IBAction func PenClicked(_ sender: UIBarButtonItem) {
        //TODO: implement Popup for Pen
        
        let popup = UIAlertController(title: "Stiftauswahl", message: "Wählen sie den gewünschten Stift und die Strichstärke", preferredStyle: .actionSheet)
        
        let back = UIAlertAction(title: "Abbrechen", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        //Todo:
        //Handle saving the new pen and thickness
        let thickness = UIAlertAction(title: "Strichdicke", style: .default) { (action) in
            
            
        }
        
        popup.addAction(thickness)
        popup.addAction(back)
        
        present(popup, animated: true)
    }
    
    @IBAction func ColorClicked(_ sender: UIBarButtonItem) {
        //TODO: implement Popup for Color
        
        let popup = UIAlertController(title: "Farbauswahl", message: "Wählen sie die gewünschte Farbe", preferredStyle: .actionSheet)
        
        let back = UIAlertAction(title: "Abbrechen", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        let black = UIAlertAction(title: "Schwarz", style: .default) { (action) in
            
            self.color = UIColor.black
            self.colorBtn.tintColor = self.color
        }
        let green = UIAlertAction(title: "Grün", style: .default) { (action) in
            
            self.color = UIColor.green
            self.colorBtn.tintColor = self.color
        }
        
        popup.addAction(black)
        popup.addAction(green)
        popup.addAction(back)
        
        present(popup, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}


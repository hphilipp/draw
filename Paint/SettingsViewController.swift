//
//  SettingsViewController.swift
//  Paint
//
//  Created by Philipp on 10.04.17.
//  Copyright © 2017 Philipp. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate : class {
    func didSelectColor(color: UIColor)
    
    func didClearForeground(clearBackground: Bool)
}

class SettingsViewController: UIViewController {

    weak var delegate : SettingsViewControllerDelegate?
    var colorPicker : SwiftHSVColorPicker!
    
    @IBOutlet var ColorPickerPresenter: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let margin : CGFloat = ColorPickerPresenter.bounds.size.width * (1/6);
        let rect = CGRect(x: margin, y: 0, width: (ColorPickerPresenter.bounds.size.width * (2/3)), height: ColorPickerPresenter.bounds.size.height)
        colorPicker = SwiftHSVColorPicker(frame: rect)
        
        ColorPickerPresenter.addSubview(colorPicker)
        colorPicker.setViewColor(UIColor.red)
    }
    
    @IBAction func colorSelected(_ sender: UIButton) {
        let popup = UIAlertController(title: "Hintergrund setzen", message: "Möchten Sie diesen Hintergrund setzen? Dafür wird das Gezeichnete gelöscht.", preferredStyle: .alert)
        
        let back = UIAlertAction(title: "Nein", style: .cancel, handler: nil)
        
        let delete = UIAlertAction(title: "Ja", style: .destructive) { (action) in
            self.delegate?.didSelectColor(color: self.colorPicker.color)
        }
        
        popup.addAction(delete)
        popup.addAction(back)
        
        present(popup, animated: true)
    }
}

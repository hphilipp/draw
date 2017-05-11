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
}

class SettingsViewController: UIViewController {

    weak var delegate : SettingsViewControllerDelegate?
    var colorPicker : SwiftHSVColorPicker!
    
    @IBOutlet var ColorPickerPresenter: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let margin : CGFloat = 10.0
        let rect = CGRect(x: margin, y: 0, width: (ColorPickerPresenter.bounds.size.width - 4*margin), height: ColorPickerPresenter.bounds.size.height)
        colorPicker = SwiftHSVColorPicker(frame: rect)
        
        ColorPickerPresenter.addSubview(colorPicker)
        colorPicker.setViewColor(UIColor.red)
    }
    
    @IBAction func colorSelected(_ sender: UIButton) {
        
        delegate?.didSelectColor(color: colorPicker.color)
    }
}

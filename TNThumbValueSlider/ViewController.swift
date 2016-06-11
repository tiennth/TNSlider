//
//  ViewController.swift
//  TNThumbValueSlider
//
//  Created by Tien on 6/9/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let slider = TNThumbValueSlider(frame: CGRect(x: 0, y: 100, width: view.frame.size.width, height: 40))
        slider.minimumValue = 100
        slider.maximumValue = 200
        slider.trackMinColor = UIColor.greenColor()
        slider.trackMaxColor = UIColor.blueColor()
        slider.value = 0.5
        slider.userInteractionEnabled = true
        view.addSubview(slider)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


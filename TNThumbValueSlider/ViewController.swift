//
//  ViewController.swift
//  TNThumbValueSlider
//
//  Created by Tien on 6/9/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit
import TNSlider

class ViewController: UIViewController {

    @IBOutlet weak var slider: TNSlider!
    @IBOutlet weak var uislider: UISlider!
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        slider.minimumValue = 100
        slider.maximumValue = 200
        slider.trackMinColor = UIColor.greenColor()
        slider.trackMaxColor = UIColor.blueColor()
        slider.userInteractionEnabled = true
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), forControlEvents: .ValueChanged)
        
        uislider.value = -10
        print(uislider.value)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(increaseProgressByOne), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func increaseProgressByOne() {
        slider.value += 1
    }
    
    func sliderValueChanged(sender: TNSlider) {
        print("Value: \(sender.value)")
    }

}


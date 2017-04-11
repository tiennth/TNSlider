//
//  ViewController.swift
//  TNSlider
//
//  Created by Tien Nguyen on 02/26/2017.
//  Copyright (c) 2017 Tien Nguyen. All rights reserved.
//

import UIKit
import TNSlider

class ViewController: UIViewController {

    @IBOutlet weak var slider: TNSlider!
    @IBOutlet weak var stepTextField: UITextField!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderValueChanged(_ sender: TNSlider) {
        print(sender.value)
    }
    
    @IBAction func minusButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func plusButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func setStepButtonClicked(_ sender: UIButton) {
        slider.step = Float(stepTextField.text ?? "0") ?? 0
        print("Step - real value: \(slider.step)")
    }
}


//
//  ViewController.swift
//  TRZForcePressGestureRecognizer
//
//  Created by Thomas Zhao on 9/22/15.
//  Copyright © 2015 Thomas Zhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel(frame: CGRectZero)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: label, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: label, attribute: .CenterY, multiplier: 1, constant: 0)
            ])

        if (traitCollection.forceTouchCapability == .Available) {
            let forcePressRecognizer = ForcePressGestureRecognizer(target: self, action: "didRecognizeForcePress:")
            
            forcePressRecognizer.numberOfTouchesRequired = 1
            forcePressRecognizer.minimumRelativeForceRequired = 0.5
            
            view.addGestureRecognizer(forcePressRecognizer)
            
            label.text = "Waiting for 3D Touch..."
        } else {
            label.text = "3D Touch Unavailable"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func didRecognizeForcePress(forcePressRecognizer: ForcePressGestureRecognizer) {
        switch forcePressRecognizer.state {
        case .Began:
            label.text = "Began"
            view.backgroundColor = UIColor.whiteColor()
        case .Changed:
            label.text = "Changed"
            let percentageComplete = min(forcePressRecognizer.averageRelativeForce / forcePressRecognizer.minimumRelativeForceRequired, 1);
            view.backgroundColor = UIColor(red: 0, green: percentageComplete, blue: 0, alpha: 1)
        case .Cancelled:
            label.text = "Cancelled"
            view.backgroundColor = UIColor.redColor()
        case .Ended:
            label.text = "Ended"
            view.backgroundColor = UIColor.greenColor()
        default: break;
        }
    }

}


//
//  SettingsViewController.swift
//  KPTVImageGallery
//
//  Created by Kyle Pontius on 1/8/16.
//  Copyright © 2016 Kyle Pontius. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - IBACTIONS -
    @IBAction func btnLightModeTapped(sender: AnyObject) {
        let viewConfig = ViewConfig(lightLevel: .Light)
        performSegueWithIdentifier("segueShowPrimaryViewController", sender: viewConfig)
    }
    
    @IBAction func btnDarkModeTapped(sender: AnyObject) {
        let viewConfig = ViewConfig(lightLevel: .Dark)
        performSegueWithIdentifier("segueShowPrimaryViewController", sender: viewConfig)
    }
    
    // MARK: - NAVIGATION -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowPrimaryViewController" {
            guard let config = sender as? ViewConfig else { return }
            let destinationViewController = segue.destinationViewController as! PrimaryViewController
            destinationViewController.viewConfiguration = config
        }
    }
}

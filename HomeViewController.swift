//
//  HomeViewController.swift
//  KPTVImageGallery
//
//  Created by Kyle Pontius on 1/10/16.
//  Copyright © 2016 Kyle Pontius. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var userSettings = ViewConfig(scaled: false, lightLevel: .Light)
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToPrimaryVC" {
            let primaryVC = segue.destinationViewController as! PrimaryViewController
            primaryVC.viewConfiguration = userSettings
        } else if segue.identifier == "segueToSettingsVC" {
            let settingsVC = segue.destinationViewController as! SettingsViewController
            settingsVC.settingsConfigurationDelegate = self
        }
    }    
}

// MARK: - SET SETTINGS DELEGATE -
extension HomeViewController: SettingsConfigurationDelegate {
    func didSetSettings(config: ViewConfig) {
        userSettings = config
    }
}
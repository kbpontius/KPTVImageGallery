//
//  Config.swift
//  KPTVImageGallery
//
//  Created by Kyle Pontius on 1/8/16.
//  Copyright © 2016 Kyle Pontius. All rights reserved.
//

import Foundation

class ViewConfig {
    
    // MARK: - CONFIGURATION ATTRIBUTES -
    
    var scaled = false
    var lightLevel = LightLevel.Light
    
    // MARK: - INITIALIZERS -
    
    required init(scaled: Bool = true, lightLevel: LightLevel = .Light) {
        self.scaled = scaled
        self.lightLevel = lightLevel
    }
}

enum LightLevel: String {
    case Light
    case Dark
}
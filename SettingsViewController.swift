//
//  SettingsViewController.swift
//  KPTVImageGallery
//
//  Created by Kyle Pontius on 1/10/16.
//  Copyright © 2016 Kyle Pontius. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - UI ELEMENTS -
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - PRIVATE PROPERTIES -
    
    private let settingsOptions:[String] = [LightLevel.Light.rawValue, LightLevel.Dark.rawValue, "Scale Images"]
    private let headerText = ["Light Level", "Image Styles"]
    private let sectionCount = [2, 1]
    private let currentViewConfiguration = ViewConfig(scaled: false, lightLevel: .Light)
    
    // MARK: - INJECTED PROPERTIES -
    
    var settingsConfigurationDelegate: SettingsConfigurationDelegate!
    
    // MARK: - VIEW PROPERTIES -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupUserSettings()
    }
    
    override func viewWillDisappear(animated: Bool) {
        returnSettings()
    }
    
    // MARK: - SETUP METHODS -
    
    // For now, this will just set up the same settings each time.
    // In the future, pull from the DB to get these settings.
    private func setupUserSettings() {
        setLightLevel(currentViewConfiguration.lightLevel)
        setScaledOption(currentViewConfiguration.scaled)
    }
    
    private func setupSettingsTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - UI METHODS -
    
    private func setLightLevel(lightLevel: LightLevel) {
        switch lightLevel {
        case .Light:
            setCheckmark(0, section: 0)
        case .Dark:
            setCheckmark(1, section: 0)
        }
    }
    
    private func setScaledOption(scaled: Bool) {
        if scaled {
            setCheckmark(0, section: 1)
        }
    }
    
    // MARK: - HELPER METHODS -
    
    private func returnSettings() {
        settingsConfigurationDelegate.didSetSettings(currentViewConfiguration)
    }
    
    // NOTE: Only call in sections where only one row can be checked.
    private func getCheckedRowInSection(section: Int) -> Int {
        for row in 0 ..< tableView.numberOfRowsInSection(section) {
            if rowIsChecked(row, section: section) {
                return row
            }
        }
        
        return -1
    }
    
    private func rowIsChecked(row: Int, section: Int) -> Bool {
        return tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section))!.accessoryType == .Checkmark
    }
    
    private func setCheckmark(row: Int, section: Int) {
        if tableView.numberOfRowsInSection(section) == 1 {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section))!.accessoryType = rowIsChecked(row, section: section) ? .None : .Checkmark
        } else {
            let rowCount = tableView.numberOfRowsInSection(section)
            
            for row in 0 ..< rowCount {
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section))!.accessoryType = .None
            }
            
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section))!.accessoryType = .Checkmark
        }
    }
    
    private func getRowNumberRelativeToTable(row: Int, section: Int) -> Int {
        var rowNumber = 0
        
        for currentSection in 0 ..< section {
            rowNumber += tableView.numberOfRowsInSection(currentSection)
        }
        
        rowNumber += row
        
        return rowNumber
    }
    
    private func modifySettings(row: Int, section: Int) {
        switch section {
        case 0:
            let selectedRow = getCheckedRowInSection(section)
            guard selectedRow >= 0 else { debugPrint("ERROR: Should not have checked row of -1."); return }
            
            switch selectedRow {
            case 0:
                currentViewConfiguration.lightLevel = .Light
            case 1:
                currentViewConfiguration.lightLevel = .Dark
            default:
                currentViewConfiguration.lightLevel = .Light
            }
        case 1:
            for row in 0 ..< tableView.numberOfRowsInSection(section) {
                if row == 0 {
                    currentViewConfiguration.scaled = rowIsChecked(row, section: section)
                }
            }
        default:
            return
        }
    }
}

// MARK: - TABLEVIEW DELEGATE METHODS -
extension SettingsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        setCheckmark(indexPath.row, section: indexPath.section)
        
        modifySettings(indexPath.row, section: indexPath.section)
    }
}

// MARK: - TABLEVIEW DATASOURCE METHODS -
extension SettingsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionCount.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionCount[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = settingsOptions[getRowNumberRelativeToTable(indexPath.row, section: indexPath.section)]
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerText[section]
    }
}

// MARK: - SETTINGS CONFIGURATION PROTOCOL -
protocol SettingsConfigurationDelegate {
    func didSetSettings(config: ViewConfig)
}
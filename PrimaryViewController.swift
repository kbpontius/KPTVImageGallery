//
//  ViewController.swift
//  KPTVImageGallery
//
//  Created by Kyle on 11/14/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit

class PrimaryViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - PRIVATE ATTRIBUTES -
    
    private var imageQueueManager: ImageQueueManager!
    private var queueTimer: NSTimer!
    private let screenBounds = UIScreen.mainScreen().bounds
    
    // MARK: - INJECTED ATTRIBUTES -
    
    var viewConfiguration: ViewConfig!
    
    private var errorCount = 0 {
        didSet {
            print("Current Error Count: \(errorCount)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidden = true
        
        setupViewConfiguration()
        
        imageQueueManager = ImageQueueManager {
            self.generateImageView()
            self.startRandomTimer()
        }
    }
    
    // MARK: - VIEW CONFIGURATION -
    
    private func setupViewConfiguration() {
        setupBackgroundLightLevel(viewConfiguration.lightLevel)
    }
    
    private func setupBackgroundLightLevel(lightLevel: LightLevel) {
        switch lightLevel {
        case .Light:
            // Don't make any changes.
            return
        case .Dark:
            // Add dark view.
            let darkView = UIView(frame: CGRectMake(0, 0, screenBounds.width, screenBounds.height))
            darkView.backgroundColor = UIColor.blackColor()
            darkView.alpha = 0.5
            view.insertSubview(darkView, atIndex: 0)
        }
    }
    
    // MARK: - GALLERY METHODS -
    
    /// This is a selector method and must remain internal.
    func generateImageView() {
        if let imageView = imageQueueManager.requestNewImage() {
            imageView.alpha = 0.0
            
            // Insert atIndex 1 b/c the LightLevel view is at 0.
            self.view.insertSubview(imageView, atIndex: 1)
            
            UIView.animateWithDuration(1, delay: 0, options: .CurveLinear, animations: {
                imageView.alpha = 1.0
            }, completion: nil)
            
            UIView.animateWithDuration(Double(self.getRand(10) + 25), delay: 0, options: .CurveLinear, animations: {
                imageView.frame.origin = self.getRandomPoint(imageView)
            }, completion: { _ in
                UIView.animateWithDuration(1, animations: {
                    imageView.alpha = 0.0
                }, completion: { _ in
                    imageView.removeFromSuperview()
                    self.imageQueueManager.recycleImageViewController(imageView)
                    print("Recycling Image")
                })
            })
        } else {
            debugPrint("ERROR: Failed to generate image.")
            // TODO: Display error when the downloadQueue fails to return an image.
        }
    }
    
    // MARK: - SWIPE METHODS -
    
    @IBAction func swipeActionCollection(sender: UISwipeGestureRecognizer) {
        switch(sender.direction) {
        case UISwipeGestureRecognizerDirection.Up:
            print("Swipe: Up!")
        case UISwipeGestureRecognizerDirection.Down:
            print("Swipe: Down!")
        case UISwipeGestureRecognizerDirection.Right:
            print("Swipe: Right!")
        case UISwipeGestureRecognizerDirection.Left:
            print("Swipe: Left")
        default:
            print("Swipe: Direction undetermined.")
        }
    }
    
    // MARK: - HELPER METHODS -
    
    private func getRandomPoint(imageView: UIImageView) -> CGPoint {
        let randX = getRand(1280)
        let extraSpace:CGFloat = -50
        return CGPointMake(randX, -imageView.frame.height + extraSpace)
    }
    
    private func getRand(seed: UInt32) -> CGFloat {
        return CGFloat(arc4random_uniform(seed) + 1)
    }
    
    private func getRandTimeInterval(seed: UInt32) -> Double {
        return Double(getRand(seed))
    }
    
    private func startRandomTimer() {
        queueTimer = NSTimer.scheduledTimerWithTimeInterval(getRandTimeInterval(5) + 10, target: self, selector: "generateImageView", userInfo: nil, repeats: true)
    }
}

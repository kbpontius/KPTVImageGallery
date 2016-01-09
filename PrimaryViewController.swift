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
    
    private var imageQueueManager: ImageQueueManager!
    private var queueTimer: NSTimer!
    
    private var errorCount = 0 {
        didSet {
            print("Current Error Count: \(errorCount)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        
        print("Screen Width: \(UIScreen.mainScreen().bounds.width)")
        
        imageQueueManager = ImageQueueManager {
            self.generateImageView()
            self.startRandomTimer()
        }
    }
    
    // MARK: - GALLERY METHODS
    
    func generateImageView() {
        if let imageView = imageQueueManager.requestNewImage() {
            imageView.alpha = 0.0
            self.view.insertSubview(imageView, atIndex: 0)
            
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
    
    // MARK: - SWIPE METHODS
    
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
    
    // MARK: - HELPER METHODS
    
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

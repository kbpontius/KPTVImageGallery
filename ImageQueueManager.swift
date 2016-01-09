//
//  DownloadQueueManager.swift
//  KPTVImageGallery
//
//  Created by Kyle on 11/15/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit

class ImageQueueManager: NSObject {
    var isStartup = false
    var queueIsReadyCallback: (()->Void)?
    var downloadTimer:NSTimer!
    
    var imageQueue = [UIImage]() {
        didSet {
//            print("Updated imageQueue - Count: \(imageQueue.count)")
            
            if isStartup && imageQueue.count > 3 {
                isStartup = false
                queueIsReadyCallback!()
            }
        }
    }
    
    var viewQueue = [UIImageView]() {
        didSet {
//            print("Updated viewQueue - Count: \(viewQueue.count)")
        }
    }
    
    // MARK: - INITALIATION
    
    convenience init(queueIsReady: ()->Void) {
        self.init()
        isStartup = true
        queueIsReadyCallback = queueIsReady
    }
    
    override init() {
        super.init()
        setupQueues()
        startDownloadTimer()
    }
    
    deinit {
        downloadTimer.invalidate()
    }
    
    // MARK: - SETUP METHODS
    
    private func setupQueues() {
        // Start downloads for imageQueue
        for _ in 1...5 {
            downloadNewImage()
        }
        
        // Setup viewQueue
        for _ in 1...10 {
            viewQueue.append(UIImageView())
        }
    }
    
    // MARK: - QUEUE API
    
    func requestNewImage() -> UIImageView? {
        if let image = imageQueue.popLast() {
            print("Image Dimensions: \(image.size.width)x\(image.size.height)")
            return generateImageViewController(image)
        } else {
            return nil
        }
    }
    
    func recycleImageViewController(imageView: UIImageView) {
        imageView.image = nil
        viewQueue.append(imageView)
    }
    
    // MARK: - HELPER METHODS
    
    func checkDownloadQueue() {
        if imageQueue.count < 10 {
            downloadNewImage()
        }
    }
    
    private func generateImageViewController(image: UIImage) -> UIImageView {
        var imageView = viewQueue.removeFirst()
        imageView.image = image
        setupDefaultImageView(&imageView)
        
        return imageView
    }
    
    private func setupDefaultImageView(inout imageView: UIImageView) {
        let x: CGFloat = self.getRand(1280)
        let y: CGFloat = 1280
        imageView.frame = CGRectMake(x, y, imageView.image!.size.width, imageView.image!.size.height)
    }
    
    private func downloadNewImage() {
        APIClient.sharedInstance.getRandomImage({ image in
            if self.imageQueue.count < 15 {
                self.imageQueue.append(image)
            }
        }, onError: { error in
            debugPrint("DOWNLOAD ERROR: \(error)")
        })
    }
    
    private func startDownloadTimer() {
        downloadTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "checkDownloadQueue", userInfo: nil, repeats: true)
    }
    
    private func getRand(seed: UInt32) -> CGFloat {
        return CGFloat(arc4random_uniform(seed) + 1)
    }
}
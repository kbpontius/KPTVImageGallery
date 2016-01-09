//
//  APIClient.swift
//  KPTVImageGallery
//
//  Created by Kyle on 11/14/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import AlamofireImage

class APIClient {
    static let sharedInstance = APIClient()
    
    private let imageDownloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(),
                                                downloadPrioritization: .FIFO,
                                                maximumActiveDownloads: 10,
                                                imageCache: nil)
    private let baseURL = "https://source.unsplash.com/category/nature/"
    private let URLRequest: NSURLRequest!
    
    private init() {
        URLRequest = NSURLRequest(URL: NSURL(string: baseURL)!)
    }
    
    func getRandomImage(onSuccess: UIImage->Void, onError: NSError->Void) {
        imageDownloader.downloadImage(URLRequest: URLRequest) { response in
            if let image = response.result.value {
                onSuccess(image)                
            } else if let error = response.result.error {
                onError(error)
            }
        }
    }
}
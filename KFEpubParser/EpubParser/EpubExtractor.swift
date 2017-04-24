//
//  EpubExtractor.swift
//  KFEpubParser
//
//  Created by zhuxuhong on 2017/4/21.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

import UIKit
import Zip

typealias EpubExtractorCompletion = (_ error: Error?) -> Void

class EpubExtractor: NSObject {
    fileprivate var epubURL: URL!
    fileprivate var destinationURL: URL!
    fileprivate var completion: EpubExtractorCompletion?{
        didSet{
            unzipEpub()
        }
    }
    
    public static let shared = EpubExtractor()    
}

extension EpubExtractor{
    public func start(epubURL: URL, destinationURL: URL, completion: EpubExtractorCompletion?){
        self.epubURL = epubURL
        self.destinationURL = destinationURL
        self.completion = completion
    }
    
    fileprivate func unzipEpub(){
        Zip.addCustomFileExtension("epub")
        
        do {
            try Zip.unzipFile(epubURL, destination: destinationURL, overwrite: true, password: nil, progress: { (progress) in
                if progress >= 1.0{
                    self.completion?(nil)
                }
            })
        }
        catch let error {
            self.completion?(error)
        }
    }
}

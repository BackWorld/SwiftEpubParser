//
//  EpubKit.swift
//  KFEpubParser
//
//  Created by zhuxuhong on 2017/4/21.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

import UIKit

typealias EpubKitCompletion = (_ content: EpubContentModel?, _ error: Error?) -> Void

class EpubKit: NSObject {
    
    public static func open(epub: URL, destination: URL, completion: EpubKitCompletion?)
    {
        EpubExtractor.shared.start(epubURL: epub, destinationURL: destination)
        { (error) in
            if let error = error{
                completion?(nil, error)
            }
            else
            {
                let parser = EpubParser(baseURL: destination)
                
                let model = EpubContentModel()
                model.metadata = parser.metadata
                model.bookType = parser.bookType
                model.bookEncryption = parser.encryption
                model.coverURL = parser.coverURL
                model.manifest = parser.manifest
                model.catalog = parser.catalog
                model.spines = parser.spines
                model.guides = parser.guides
                model.isRTL = parser.isRTL
                
                completion?(model, nil)
            }
        }
    }
}

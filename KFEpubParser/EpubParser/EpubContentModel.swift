//
//  EpubContentModel.swift
//  KFEpubParser
//
//  Created by zhuxuhong on 2017/4/21.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

import UIKit
import SwiftyXMLParser

class EpubCatalogItem: NSObject {
    var id = ""
    var order = "0"
    var text = ""
    var src = ""
    var subs = [EpubCatalogItem]()
    var depth = 0
    
    public static func from(xml: XML.Accessor, depth: Int) -> EpubCatalogItem{
        let item = EpubCatalogItem()
        item.id = xml.attributes["id"] ?? ""
        item.order = xml.attributes["playOrder"] ?? "0"
        item.text = xml["navLabel","text"].text ?? ""
        item.src = xml["content"].attributes["src"] ?? ""
        item.depth += 1
        
        for xmlItem in xml["navPoint"] {
            let subItem = EpubCatalogItem.from(xml: xmlItem, depth: item.depth)
            item.subs.append(subItem)
        }
        
        return item
    }
}

class EpubManifestItem: NSObject {
    var id = ""
    var href = ""
    var type = ""
    
    public static func from(xml: XML.Accessor) -> EpubManifestItem{
        let item = EpubManifestItem()
        
        item.id = xml.attributes["id"] ?? ""
        item.href = xml.attributes["href"] ?? ""
        item.type = xml.attributes["media-type"] ?? ""
        
        return item
    }
}

class EpubMetadata: NSObject {
    var title = ""
    var creator = ""
    var descript = ""
    var language = ""
    var date = ""
    var contributor = ""
    var publisher = ""
    var subject = ""
    var identifier = ""
    var coverId = ""

    public static func from(xml: XML.Accessor) -> EpubMetadata{
        let data = EpubMetadata()
        
        data.title = xml["dc:title"].text ?? ""
        data.creator = xml["dc:creator"].text ?? ""
        data.coverId = xml["meta"].attributes["content"] ?? ""
        
        return data
    }
}

class EpubContentModel: NSObject {
    
    var bookType: EpubBookType = .unknown
    var bookEncryption: EpubBookEncryption = .none
    
    var metadata: EpubMetadata?
    var coverURL: URL? //封面图
    var manifest: [String: EpubManifestItem]?
    var spines: [String]?
    var guides: [String]?
    var catalog: [EpubCatalogItem]?
    var isRTL = false
}

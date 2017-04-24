//
//  EpubParser.swift
//  KFEpubParser
//
//  Created by zhuxuhong on 2017/4/21.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

import UIKit
import SwiftyXMLParser

class EpubParser: NSObject {
    fileprivate var baseURL: URL?
    
    convenience init(baseURL: URL?){
        self.init()
        self.baseURL = baseURL
    }
    
    open var bookType: EpubBookType
    {
        if let mimetypeURL = baseURL?.appendingPathComponent("mimetype"),
            let mimetype = try? String(contentsOf: mimetypeURL)
        {
            
            if mimetype == BookMimeType.epub {
                return .epub2
            }
            else if mimetype == BookMimeType.iBooks {
                return .iBook
            }
        }
        return .unknown
    }
    
    open var encryption: EpubBookEncryption
    {
        if let sinfURL = baseURL?.appendingPathComponent("META-INF").appendingPathComponent("sinf.xml"),
            let content = try? String(contentsOf: sinfURL),
            let xml = try? XML.parse(content),
            let sinf = xml["fairplay","sinf"].all
        {
            if !sinf.isEmpty {
                return .fairplay
            }
        }
        
        return .none
    }
    
    open var rootFileURL: URL?
    {
        if let containerURL = baseURL?.appendingPathComponent("META-INF").appendingPathComponent("container.xml"),
            let content = try? String(contentsOf: containerURL),
            let xml = try? XML.parse(content),
            let path = xml["container","rootfiles","rootfile"].attributes["full-path"]
        {
            return baseURL?.appendingPathComponent(path)
        }
        
        return nil
    }
    
    open var coverURL: URL?
    {
        if let xml = rootFile,
            let coverId = metadata?.coverId
        {
            let item = xml["manifest","item"].filter{
                $0.attributes["id"] == coverId
            }.first
            let href = item?.attributes["href"] ?? ""
            return rootFileURL?.appendingPathComponent(href)
        }
        return nil
    }
    
    open var metadata: EpubMetadata?
    {
        if let xml = rootFile
        {
            return EpubMetadata.from(xml: xml["package","metadata"])
        }
        return nil
    }
    
    open var manifest: [String: EpubManifestItem]?{
        if let xml = rootFile
        {
            var items = [String: EpubManifestItem]()
            for xmlItem in xml["manifest","item"] {
                let item = EpubManifestItem.from(xml: xmlItem)
                items.updateValue(item, forKey: item.id)
            }
            return items
        }
        
        return nil
    }
    
    open var spines: [String]?{
        if let xml = rootFile
        {
            var items = [String]()
            for item in xml["spine","itemref"] {
                items.append(item.attributes["idref"] ?? "")
            }
            return items
        }
        return nil
    }
    
    open var guides: [String]?{
        if let xml = rootFile
        {
            var items = [String]()
            for item in xml["guide","reference"] {
                items.append(item.attributes["href"] ?? "")
            }
            return items
        }
        return nil
    }
    
    open var catalog: [EpubCatalogItem]?{
        if  let manifest = self.manifest,
            let toc = manifest["ncx"],
            let url = rootFileURL?.deletingLastPathComponent().appendingPathComponent(toc.href),
            let content = try? String(contentsOf: url),
            let xml = try? XML.parse(content)
        {
            var items = [EpubCatalogItem]()
            for xmlItem in xml["ncx","navMap","navPoint"] {
                items.append(EpubCatalogItem.from(xml: xmlItem, depth: 0))
            }
            return items
        }
        return nil
    }
    
    open var isRTL: Bool{
        if let xml = rootFile,
            let rtl = xml["spine"].attributes["page-progression-direction"]{
            return rtl == "rtl"
        }
        return false
    }
    
    fileprivate var rootFile: XML.Accessor?{
        if let url = rootFileURL,
            let content = try? String(contentsOf: url),
            let xml = try? XML.parse(content){
            return xml["package"]
        }
        return nil
    }
}

//
//  EpubParserMacro.swift
//  KFEpubParser
//
//  Created by zhuxuhong on 2017/4/21.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

import Foundation

enum EpubBookType: String {
    case unknown
    case epub2
    case epub3
    case iBook
}

enum EpubBookEncryption: String {
    case none
    case fairplay
}

let BookMimeType = (
    epub: "application/epub+zip",
    iBooks: "application/x-ibooks+zip"
)

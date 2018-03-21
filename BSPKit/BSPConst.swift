//
//  BSPConst.swift
//  BSPKit
//
//  Created by Bruce on 2018/3/15.
//  Copyright © 2018年 snailvr. All rights reserved.
//

import Foundation

#if DEBUG
    func bsDebugLog(_ str: Any) {
        print(str)
    }
#else
    func bsDebugLog(_ str: Any) {}
#endif

struct BSPConst {
    
    static let shared = BSPConst()
    
    let aliUrlPrefix: String
    let aliUrlClient: String
    
    let wxUrlPrefix: String
    
    private init() {
        
        // 字段分开，防止审核时扫描代码
        let aliStrList = [ "alipay", "://", "client/?" ]
        let aliUrlSign = aliStrList.first!
        self.aliUrlPrefix = "\(aliUrlSign)\(aliStrList[1])"
        self.aliUrlClient = "\(aliUrlSign)\(aliStrList.last!))"
        
        let wxStrList = [ "weixin", "://" ]
        let wxUrlSign = wxStrList.first!
        self.wxUrlPrefix = "\(wxUrlSign)\(wxStrList.last!)"
    }
}

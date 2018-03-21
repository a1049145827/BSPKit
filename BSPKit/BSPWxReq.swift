//
//  BSPWxReq.swift
//  BSPKit
//
//  Created by Bruce on 2018/3/15.
//  Copyright © 2018年 snailvr. All rights reserved.
//

import Foundation

class XHPWxReq: NSObject {
    /** 微信开放平台审核通过的应用APPID*/
    
    var openID = ""
    /** 商户号 */
    var partnerId = ""
    /** 交易会话ID */
    var prepayId = ""
    /** 随机串，防重发 */
    var nonceStr = ""
    /** 时间戳，防重发 */
    var timeStamp: UInt32 = 0
    /** 扩展字段 */
    var package = ""
    /** 签名 */
    var sign = ""
}

//
//  BSPWxReq.swift
//  BSPKit
//
//  Created by Bruce on 2018/3/15.
//  Copyright © 2018年 snailvr. All rights reserved.
//

import Foundation

public class BSPWxReq {
    /** 微信开放平台审核通过的应用APPID*/
    
    public var openID = ""
    /** 商户号 */
    public var partnerId = ""
    /** 交易会话ID */
    public var prepayId = ""
    /** 随机串，防重发 */
    public var nonceStr = ""
    /** 时间戳，防重发 */
    public var timeStamp: UInt32 = 0
    /** 扩展字段 */
    public var package = ""
    /** 签名 */
    public var sign = ""
    
    public init() { }
}

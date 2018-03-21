//
//  BSPKit.swift
//  BSPKit
//
//  Created by Bruce on 2018/3/20.
//  Copyright © 2018年 snailvr. All rights reserved.
//

import Foundation

public typealias CompletedBlock = ((_ resultDict: [AnyHashable: Any]) -> Void)

class BSPKit {
    
    static let defaultManager = BSPKit()
    
    var completedBlock: CompletedBlock? = nil
    var wxAppid: String? = nil
    
    private init() {
        
    }
    
    class func isWxAppInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: BSPConst.shared.wxUrlPrefix)!)
    }
    
    class func isAliAppInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: BSPConst.shared.aliUrlPrefix)!)
    }
    
    func wxpOrder(_ req: XHPWxReq, completed completedBlock: CompletedBlock? = nil) {
        
        if !BSPKit.isWxAppInstalled() {
            bsDebugLog("未安装微信")
            return
        }
        
        wxAppid = req.openID
        
        req.package = req.package.replacingOccurrences(of: "=", with: "%3D")
        
        let parameter = "nonceStr=\(req.nonceStr)&package=\(req.package)&partnerId=\(req.partnerId)&prepayId=\(req.prepayId)&timeStamp=\(req.timeStamp)&sign=\(req.sign)&signType=\("SHA1")"
        let openUrl = "\(BSPConst.shared.wxUrlPrefix)/\(req.openID)/pay/?\(parameter)"
        if nil != completedBlock {
            self.completedBlock = completedBlock
        }
        if let aUrl = URL(string: openUrl) {
            UIApplication.shared.openURL(aUrl)
        }
    }
    
    func alipOrder(_ orderStr: String?, fromScheme schemeStr: String?, completed completedBlock: CompletedBlock?) {
        if orderStr == nil {
            bsDebugLog("缺少orderStr参数")
            return
        }
        if schemeStr == nil {
            bsDebugLog("缺少schemeStr参数")
            return
        }
        if !BSPKit.isAliAppInstalled() {
            bsDebugLog("未安装某宝")
            return
        }
        let dict: NSDictionary = ["fromAppUrlScheme": schemeStr as Any, "requestType": "SafePay", "dataString": orderStr as Any]
        let dictEncodeString = (dict.bs.jsonString as NSString?)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let openUrl = "\(BSPConst.shared.aliUrlPrefix)\(BSPConst.shared.aliUrlClient)\(dictEncodeString ?? "")"
        if nil != completedBlock {
            self.completedBlock = completedBlock
        }
        if let aUrl = URL(string: openUrl) {
            UIApplication.shared.openURL(aUrl)
        }
    }
    
    func handleOpen(_ url: URL?) -> Bool {
        
        let urlString = (url?.absoluteString as NSString?)?.removingPercentEncoding
        
        let hasSafeP: Bool? = ((urlString as NSString?)?.contains("//safepay/"))
        
        if (hasSafeP != nil && hasSafeP! == true) {
            var resultStr: String? = urlString?.components(separatedBy: "?").last
            resultStr = resultStr?.replacingOccurrences(of: "ResultStatus", with: "resultStatus")
            let result = (resultStr as NSString?)?.bs.toDictionary
            let resultDict = result?["memo"] as? [AnyHashable: Any]
            if completedBlock != nil && resultDict != nil {
                completedBlock!(resultDict!)
            }
            return true
        }
        
        var hasWxAppId: Bool? = nil
        
        if wxAppid != nil {
            hasWxAppId = (urlString as NSString?)?.contains(wxAppid!)
        }
        
        if hasWxAppId != nil && hasWxAppId == true {
            let retArray = urlString?.components(separatedBy: "&")
            var errCode: Int = -1
            var errStr = "普通错误"
            
            if let _ = retArray {
                for retStr: String in retArray! {
                    if retStr.contains("ret=") {
                        errCode = Int(retStr.replacingOccurrences(of: "ret=", with: "")) ?? 0
                    }
                }
            }
            
            if errCode == 0 {
                errStr = "成功"
            }
            else if errCode == -2 {
                errStr = "用户取消"
            }
            else if errCode == -3 {
                errStr = "发送失败"
            }
            else if errCode == -4 {
                errStr = "授权失败"
            }
            else if errCode == -5 {
                errStr = "微信不支持"
            }
            
            let resultDict = ["errCode": errCode, "errStr": errStr] as [String : Any]
            if completedBlock != nil {
                completedBlock!(resultDict)
            }
            return true
        }
        
        return false
    }
}

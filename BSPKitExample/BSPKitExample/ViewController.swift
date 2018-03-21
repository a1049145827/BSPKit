//
//  ViewController.swift
//  BSPKitExample
//
//  Created by Bruce on 2018/3/21.
//  Copyright © 2018年 snailvr. All rights reserved.
//

import UIKit
import BSPKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - lazy
    
    lazy var dataArray: [String]? = ["微信支付", "支付宝支付"]
    
    lazy var tableView: UITableView? = {
        let _tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.tableFooterView = UIView()
        
        return _tableView
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let aView = tableView {
            view.addSubview(aView)
        }
        let alert = UIAlertView(title: """
            提示:
            请替换支付参数为真实数据,
            便可进行实际支付
            """, message: "", delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
    
    // MARK: - tableView DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = dataArray?[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            // 微信支付
            if !BSPKit.isWxAppInstalled() {
                print("未安装微信")
                return
            }
            // 微信支付参数,下面7个参数,由后台签名订单后生成,并返回给客服端(与官方SDK一致)
            // 注意:请将下面参数设置为你自己真实订单签名后服务器返回参数,便可进行实际支付
            // 以下参数详细介绍见
            // 微信官方文档:https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_12&index=2
            let req = BSPWxReq()
            req.openID = ""
            // 微信开放平台审核通过的应用APPID
            req.partnerId = ""
            // 商户号
            req.prepayId = ""
            // 交易会话ID
            req.nonceStr = ""
            // 随机串，防重发
            req.timeStamp = 1518156229
            // 时间戳，防重发
            req.package = ""
            // 扩展字段,暂填写固定值Sign=WXPay
            req.sign = ""
            // 签名
            // 传入订单模型,拉起微信支付
            BSPKit.defaultManager.wxpOrder(req, completed: {(_ resultDict: [AnyHashable: Any]) -> Void in
                print("支付结果: \(resultDict)")
                
                let code = resultDict["errCode"] as? Int
                
                if code == 0 {
                    // 支付成功
                    print("微信 支付成功！")
                }
            })
        } else if indexPath.row == 1 {
            // 支付宝支付
            if !BSPKit.isAliAppInstalled() {
                print("未安装支付宝")
                return
            }
            //支付宝订单签名,此签名由后台签名订单后生成,并返回给客户端(与官方SDK一致)
            //注意:请将下面值设置为你自己真实订单签名,便可进行实际支付
            let orderSign = "appId=1488357918048444&mhtCharset=UTF-8&mhtCurrencyType=156&mhtOrderAmt=1&mhtOrderDetail=%E5%8D%95%E4%B8%AA%E4%BB%98%E8%B4%B9%E8%8A%82%E7%9B%AE1012%20%E8%A7%82%E7%9C%8B%E5%88%B8&mhtOrderName=%E5%8D%95%E4%B8%AA%E4%BB%98%E8%B4%B9%E8%8A%82%E7%9B%AE1012%20%E8%A7%82%E7%9C%8B%E5%88%B8&mhtOrderNo=tradeno_201803211516361751c2978b7e78b4fb&mhtOrderStartTime=20180321151636&mhtOrderTimeOut=3600&mhtOrderType=01&notifyUrl=https://vrtest-api.aginomoto.com/newVR-report-service/thirdPartyPay/nowpayCallBack&payChannelType=12&mhtSignature=3e6ca36197963878a3cc21c5ff43cb84&mhtSignType=MD5"
            //传入支付宝订单签名 和 自己App URL Scheme,拉起支付宝支付
            BSPKit.defaultManager.alipOrder(orderSign, fromScheme: "whaleyvr", completed: {(_ resultDict: [AnyHashable: Any]) -> Void in
                print("支付结果: \(resultDict)")
                
                var status = -1
                if let num = resultDict["resultStatus"] as? Int {
                    status = num
                }
                
                if status == 9000 {
                    // 支付成功
                    print("支付宝 支付成功！")
                }
            })
        }
    }
    
    // MARK: - tableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray!.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
    }
}


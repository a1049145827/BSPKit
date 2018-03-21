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
            """, message: "", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "")
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
            let orderSign = "2018010801689398&biz_content=%7b%22timeout_express%22%3a%2230m%22%2c%22seller_id%22%3a%22pay%40qianzhan.com%22%2c%22product_code%22%3a%22QUICK_MSECURITY_PAY%22%2c%22total_amount%22%3a%220.01%22%2c%22subject%22%3a%2230%e5%a4%a9%e4%bd%bf%e7%94%a8%e6%9c%9f%e9%99%90%22%2c%22body%22%3a%2230%e5%a4%a9%e4%bd%bf%e7%94%a8%e6%9c%9f%e9%99%90%22%2c%22out_trade_no%22%3a%22data-180209-9913b1d3%22%7d&charset=utf-8&method=alipay.trade.app.pay&notify_url=https%3a%2f%2fappecV2.paipai123.com%2fapi%2fAlipay%2fAliPayNotify&sign_type=RSA2&timestamp=2018-02-23 10%3a54%3a15&version=1.0&sign=d4zihRv9g6OdzI7Tdh64iFarDajKUqcAGWzU9wB29g7X1w6NE5v9Zed2WwCNJFsZf%2fnwtgGQ24m5Ce4%2fxm2jzgyMO2NvRIWnnXO3sUKdBlGNEZeq034j3c3ZZ8L7p830TYRKecaxKt9%2bf%2fkCw67GN1%2bBwgPM1zdAB4xoD%2bqxrtJN79sCuc3xSaBojOWPm%2f9g0bQvd4VBP6ZzxLlbtVt0Yg5Nw2dY0gW4fiEJXfbPeCVW6gSa07bbEb%2fSbbWSgRJfNP%2f%2fi9jkM4Y9%2fLw3Jvj6wH792NUCieWvrIfl6BGiAY6PR0YKLM%2baskr6qkFX3D5H%2bTf6z%2bmf40bT8v74WaBnng%3d%3d"
            //传入支付宝订单签名 和 自己App URL Scheme,拉起支付宝支付
            BSPKit.defaultManager.alipOrder(orderSign, fromScheme: "BSPKitExample", completed: {(_ resultDict: [AnyHashable: Any]) -> Void in
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


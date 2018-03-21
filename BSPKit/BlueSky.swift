//
//  BlueSky.swift
//  BSPKit
//
//  Created by Bruce on 2018/3/20.
//  Copyright © 2018年 snailvr. All rights reserved.
//

import Foundation

public final class BlueSky<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol BlueSkyConvertible {
    associatedtype ConvertibleType
    
    var bs: ConvertibleType { get }
}

public extension BlueSkyConvertible {
    public var bs: BlueSky<Self> {
        get { return BlueSky(self) }
    }
}

extension NSDictionary: BlueSkyConvertible { }
extension NSString: BlueSkyConvertible { }

extension BlueSky where Base: NSDictionary {
    
    /// convert NSDictionary Object to String Value
    public var jsonString: String? {
        
        get {
            
            var string: String? = nil
            
            do {
                let data = try JSONSerialization.data(withJSONObject: self.base, options: .prettyPrinted)
                string = String(data: data, encoding: .utf8)
                
            } catch let err {
                print(err)
            }
            
            return string
        }
    }
}

extension BlueSky where Base: NSString {
    
    /// convert NSString Object to Dictionary Value
    public var toDictionary: Dictionary<String, Any>? {
        
        get {
            
            var dict: Dictionary<String, Any>? = nil
            
            do {
                let data = self.base.data(using: String.Encoding.utf8.rawValue)
                
                dict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, Any>
                
            } catch let err {
                print(err)
            }
            
            return dict
        }
    }
}

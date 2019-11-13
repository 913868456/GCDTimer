//
//  Codable+Tools.swift
//  GFExtensions
//
//  Created by 防神 on 2019/11/13.
//  Copyright © 2019 吃面多放葱. All rights reserved.
//

import Foundation

extension KeyedDecodingContainerProtocol {
    func decode<T>(_ key: Self.Key) throws -> T? where T: Decodable {
        if contains(key) {
            return try decodeIfPresent(T.self, forKey: key)
        } else {
            return nil
        }
    }
    
    func decode<T>(_ key: Self.Key, default defaultExpression: @autoclosure () -> T) throws -> T where T: Decodable {
        if contains(key) {
            #if DEBUG
            // 开发阶段，类型不匹配会抛出异常
            return try decodeIfPresent(T.self, forKey: key) ?? defaultExpression()
            #else
            return (try? decodeIfPresent(T.self, forKey: key)) ?? defaultExpression()
            #endif
        } else {
            return defaultExpression()
        }
    }
    
    func decodeToInt(_ keys: Self.Key..., default value: Int) -> Int {
        var result: Int?
        
        for key in keys {
            guard contains(key) else { continue }
            
            if let v = try? decodeIfPresent(Int.self, forKey: key) {
                result = v
            } else if let v = try? decodeIfPresent(Bool.self, forKey: key) {
                result = v ? 1 : 0
            } else if let v = try? decodeIfPresent(String.self, forKey: key), let vInt = Int(v) {
                result = vInt
            }
            
            if result != nil { break }
        }
        
        return result ?? value
    }
    
    func decodeToDouble(_ keys: Self.Key..., default value: Double) -> Double {
        var result: Double?
        
        for key in keys {
            guard contains(key) else { continue }
            
            if let v = try? decodeIfPresent(Double.self, forKey: key) {
                result = v
            } else if let v = try? decodeIfPresent(Int.self, forKey: key) {
                result = Double(v)
            } else if let v = try? decodeIfPresent(Bool.self, forKey: key) {
                result = v ? 1 : 0
            } else if let v = try? decodeIfPresent(String.self, forKey: key), let vDouble = Double(v) {
                result = vDouble
            }
            
            if result != nil { break }
        }
        
        return result ?? value
    }
    
    func decodeToBool(_ keys: Self.Key..., default value: Bool) -> Bool {
        var result: Bool?
        
        for key in keys {
            guard contains(key) else { continue }
            
            if let v = try? decodeIfPresent(Bool.self, forKey: key) {
                result = v
            } else if let v = try? decodeIfPresent(Int.self, forKey: key) {
                result = v != 0
            } else if let v = try? decodeIfPresent(String.self, forKey: key) {
                if let vInt = Int(v) {
                    result = vInt != 0
                } else if v == "YES" || v == "yes" || v == "TRUE" || v == "true" {
                    result = true
                } else if v == "NO" || v == "no" || v == "FALSE" || v == "false" {
                    result = false
                }
            }
            
            if result != nil { break }
        }
        
        return result ?? value
    }
    
    func decodeToString(_ keys: Self.Key..., default value: String = "") -> String {
        var result: String?
        
        for key in keys {
            guard contains(key) else { continue }
            
            if let v = try? decodeIfPresent(String.self, forKey: key) {
                result = v
                break
            } else if let v = try? decodeIfPresent(Int.self, forKey: key) {
                result = String(v)
                break
            } else if let v = try? decodeIfPresent(Bool.self, forKey: key) {
                result = String(v ? "1" : "0")
                break
            }
        }
        
        return result ?? value
    }
}


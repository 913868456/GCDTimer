//
//  Extension+Foundation.swift
//  GFExtensions
//
//  Created by 防神 on 2018/8/3.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

import Foundation

extension Data {
    var gf_hexString: String { // 将Data转换为String
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Date {
    /// 返回指定格式的日期字符串
    ///
    /// - Parameter formatter: e.g. "yyyy-MM-dd HH:ss"
    /// - Returns: e.g. "2019-05-01 13:23"
    func gf_string(with formatter: String) -> String {
        let df = DateFormatter()
        df.dateFormat = formatter
        df.locale = NSLocale.current
        return df.string(from: self)
    }

    /// 时间戳初始化为Date
    static func gf_timeStampDate(milliseconds: Int) -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
        return date
    }

    /// 获取系统时间戳
    ///
    /// - Returns: timeStamp since 1970
    static func gf_getSystimeStamp() -> String {
        let timeStamp = Date().timeIntervalSince1970 * 1000
        return "\(timeStamp)"
    }
}

// MARK: - 正则校验

extension String {
    // 电话号码
    var gf_isPhoneNumber: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(\\+86){0,1}1[3|4|5|6|7|8|9](\\d){9}$")
        return predicate.evaluate(with: self)
    }

    // 企业名称
    var gf_isEnterprise: Bool {
        let regex = "^[A-Za-z0-9\\u4e00-\\u9fa5]{2,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    // 统一社会信用代码
    var gf_isEnterpriseCardID: Bool {
        let regex = "[0-9A-HJ-NPQRTUWXY]{2}\\d{6}[0-9A-HJ-NPQRTUWXY]{10}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    // 邮箱
    var gf_isEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    // 身份证
    var gf_isUserID: Bool {
        let regex = "(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    // IP地址
    var gf_isIP: Bool {
        let regex = "((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    // 车牌号
    var gf_isCarID: Bool {
        let regex = "^[\\u4e00-\\u9fa5]{1}[a-hj-zA-HJ-Z]{1}[a-hj-zA-HJ-Z_0-9]{4}[a-hj-zA-HJ-Z_0-9_\\u4e00-\\u9fa5]$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    // 企业注册号
    var gf_isRegisterCode: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^[0-9\\u4e00-\\u9fa5]{0,7}[0-9]{6,13}[u4e00-\\u9fa5]{0,1}$")
        return predicate.evaluate(with: self)
    }
}

// MARK: String 格式处理

extension String {
    var int: Int? {
        return Int(self)
    }

    var url: URL? {
        return URL(string: self)
    }

    var float: Float? {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }

    var double: Double? {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
    
    var trim: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func gf_trimZero() -> String {
        if self == "0" {
            return self
        }
        var string = trimmingCharacters(in: ["0"])
        // 第一个字符如果是".",则补"0"
        if string.first == "." {
            string.insert("0", at: string.startIndex)
        }

        if string.hasSuffix(".") {
            let i = string.firstIndex(of: ".")!
            string.remove(at: i)
        }
        return string
    }

    func gf_formatAttributeString(_ leftAttrs: [NSAttributedString.Key: Any]? = nil, _ rightAttrs: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString {
        if contains(".") {
            let strArr = components(separatedBy: ["."])
            let str = NSMutableAttributedString()
            let leftAttrStr = NSMutableAttributedString(string: strArr[0], attributes: leftAttrs)
            let rightAttrStr = NSMutableAttributedString(string: strArr[1], attributes: rightAttrs)
            let dotAttrStr = NSMutableAttributedString(string: ".", attributes: leftAttrs)
            str.append(leftAttrStr)
            str.append(dotAttrStr)
            str.append(rightAttrStr)
            return str
        } else {
            return NSAttributedString(string: self, attributes: leftAttrs)
        }
    }

    func gf_dateFromISO8601() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        return formatter.date(from: self)
    }
}


extension Collection { // 数组越界解决方案
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension GFCompat where Base: FileManager {
    static func docDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }

    static func cacheDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }

    static func tempFilePathWithExtension(theExtension: String) -> URL? {
        return URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(theExtension)
    }
}

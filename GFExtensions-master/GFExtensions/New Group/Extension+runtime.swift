//
//  Extension+runtime.swift
//  GFExtensions
//
//  Created by 防神 on 2019/11/13.
//  Copyright © 2019 吃面多放葱. All rights reserved.
//

import Foundation
import ObjectiveC

public protocol AssociatedObjectStore {}

extension AssociatedObjectStore {
    public func setAssociatedObject<T>(_ object: T?, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    public func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }

    public func associatedObject<T>(forKey key: UnsafeRawPointer, default: @autoclosure () -> T) -> T {
        if let object: T = self.associatedObject(forKey: key) {
            return object
        }
        let object = `default`()
        self.setAssociatedObject(object, forKey: key)
        return object
    }
}

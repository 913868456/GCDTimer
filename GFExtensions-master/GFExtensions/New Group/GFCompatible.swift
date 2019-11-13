//
//  GFCompatible.swift
//  GFExtensions
//
//  Created by 防神 on 2019/6/3.
//  Copyright © 2019 吃面多放葱. All rights reserved.
//

import Foundation

public struct GFCompat<Base> {
    public let base: Base
    public init(_ base: Base){
        self.base = base
    }
}

public protocol GFCompatible {
    associatedtype CompatibleType
    static var gf: GFCompat<CompatibleType>.Type { get set }
    var gf: GFCompat<CompatibleType> { get set }
}

extension GFCompatible {
    public static var gf: GFCompat<Self>.Type {
        get {
            return GFCompat<Self>.self
        }
        set {
            // this enables using GfCompat to "mutate" base type
        }
    }
    public var gf: GFCompat<Self> {
        get {
            return GFCompat(self)
        }
        set {
            // this enables using GfCompat to "mutate" base type

        }
    }
}

import class Foundation.NSObject

/// Extend NSObject with `gf` proxy.
extension NSObject: GFCompatible { }

//
//  Extension+UIKit.swift
//  GFExtensions
//
//  Created by 防神 on 2018/8/3.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

import Foundation
import UIKit

extension GFCompat where Base: UIViewController {
    func setStatusBarColor(color: UIColor) {
        if UIScreen.gf.isFullScreen {
            if let statusWin = UIApplication.shared.value(forKey: "statusBarWindow") as? UIView {
                if let statusBar = statusWin.value(forKey: "statusBar") as? UIView {
                    statusBar.backgroundColor = color
                }
            }
        }
    }

    func popAction() {
        base.navigationController?.popViewController(animated: true)
    }

    func dismissAction() {
        base.dismiss(animated: true, completion: nil)
    }
}

extension GFCompat where Base: UINavigationController {
    func backgroundAlpha(alpha: CGFloat) {
        if let barBackgroundView = base.navigationBar.subviews.first {
            if #available(iOS 11.0, *) {
                if base.navigationBar.isTranslucent {
                    for view in barBackgroundView.subviews {
                        view.alpha = alpha
                    }
                } else {
                    barBackgroundView.alpha = alpha
                }
            } else {
                barBackgroundView.alpha = alpha
            }
        }
    }
}

extension NSMutableAttributedString {
    convenience init(string: String, color: UIColor, font: UIFont) {
        let attrs = [NSAttributedString.Key.foregroundColor: color,
                     NSAttributedString.Key.font: font]
        self.init(string: string, attributes: attrs)
    }
}

extension GFCompat where Base: UIScreen {
    // Size
    static var isFullScreen: Bool {
        if #available(iOS 11, *) {
            guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                return false
            }

            if unwrapedWindow.safeAreaInsets.bottom > 0 {
                print(unwrapedWindow.safeAreaInsets)
                return true
            }
        }
        return false
    }

    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }

    static var navigationBarHeight: CGFloat {
        return statusBarHeight + 44
    }

    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }

    static var bottomBarHeight: CGFloat {
        return isFullScreen ? 83 : 49
    }

    static var topOffset: CGFloat {
        if #available(iOS 11.0, *), let keywindow = UIApplication.shared.keyWindow {
            return keywindow.safeAreaInsets.top
        } else {
            return 0
        }
    }

    static var bottomOffset: CGFloat {
        if #available(iOS 11.0, *), let keywindow = UIApplication.shared.keyWindow {
            return keywindow.safeAreaInsets.bottom
        } else {
            return 0
        }
    }
}

extension GFCompat where Base: UIView {
    var x: CGFloat {
        set {
            base.frame.origin.x = newValue
        }
        get {
            return base.frame.origin.x
        }
    }

    var y: CGFloat {
        set {
            base.frame.origin.y = newValue
        }
        get {
            return base.frame.origin.y
        }
    }

    var width: CGFloat {
        set {
            base.frame.size.width = newValue
        }
        get {
            return base.frame.size.width
        }
    }

    var height: CGFloat {
        set {
            base.frame.size.height = newValue
        }
        get {
            return base.frame.size.height
        }
    }

    var center: CGPoint {
        set {
            base.center = newValue
        }
        get {
            return base.center
        }
    }

    var centerX: CGFloat {
        set {
            base.center.x = newValue
        }
        get {
            return base.center.x
        }
    }

    var centerY: CGFloat {
        set {
            base.center.y = newValue
        }
        get {
            return base.center.y
        }
    }

    var top: CGFloat {
        return base.frame.minY
    }

    var bottom: CGFloat {
        return base.frame.maxY
    }

    var left: CGFloat {
        return base.frame.minX
    }

    var right: CGFloat {
        return base.frame.maxX
    }
    
    // MARK: 像素取整
    static func snap(_ x: CGFloat) -> CGFloat {
        let scale = UIScreen.main.scale
        return ceil(x * scale) / scale
    }

    static func snap(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: snap(point.x), y: snap(point.y))
    }

    static func snap(_ size: CGSize) -> CGSize {
        return CGSize(width: snap(size.width), height: snap(size.height))
    }

    static func snap(_ rect: CGRect) -> CGRect {
        return CGRect(origin: snap(rect.origin), size: snap(rect.size))
    }


    // MARK: View 画圆角

    func roundCorners(radius: CGFloat, _ corners: UIRectCorner = UIRectCorner.allCorners) {
        let rect = CGRect(x: 0, y: 0, width: base.bounds.width, height: base.bounds.height)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))

        if radius == 0 {
            base.layer.mask = nil
        } else {
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            mask.frame = rect
            base.layer.mask = mask
        }
    }

    // MARK: 过渡色

    @discardableResult func addGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = base.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        base.layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    // MARK: 获取View的第一响应者

    var firstResponder: UIView? {
        guard !base.isFirstResponder else { return base }
        for subview in base.subviews {
            if let firstResponder = subview.gf.firstResponder {
                return firstResponder
            }
        }
        return nil
    }

    // MARK: - 截屏

    func screenShot() -> UIImage? {
        var image: UIImage?

        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.opaque = base.isOpaque
            let renderer = UIGraphicsImageRenderer(size: base.frame.size, format: format)
            image = renderer.image { _ in
                base.drawHierarchy(in: base.frame, afterScreenUpdates: true)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(base.frame.size, base.isOpaque, UIScreen.main.scale)
            base.drawHierarchy(in: base.frame, afterScreenUpdates: true)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image
    }

    // MARK: 获取当前控制器

    func ownerController() -> UIViewController? {
        var n = base.next
        while n != nil {
            if n is UIViewController {
                return n as? UIViewController
            }
            n = n?.next
        }
        return nil
    }

    // MARK: 阴影

    func addShadow(color: UIColor = UIColor.black.withAlphaComponent(0.05), offset: CGSize = .zero, opacity: Float = 1, shadowRadius: CGFloat = 11) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowOffset = offset
        base.layer.shadowOpacity = opacity
        base.layer.shadowRadius = shadowRadius
    }

    func removeShadow() {
        base.layer.shadowColor = nil
        base.layer.shadowOffset = .zero
        base.layer.shadowOpacity = 0
        base.layer.shadowRadius = 0
    }

    // MARK: UIViewAnimation

    static func transformRotate(view: UIView, duration: TimeInterval, rotationAngle angle: CGFloat) {
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform(rotationAngle: angle)
        }
    }

    static func transformTranslate(view: UIView, duration: TimeInterval, translationX tx: CGFloat, y ty: CGFloat) {
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform(translationX: tx, y: ty)
        }
    }

    static func transformScale(view: UIView, duration: TimeInterval, scaleX sx: CGFloat, y sy: CGFloat) {
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform(scaleX: sx, y: sy)
        }
    }

    // MARK: 虚线

    func drawDashLine(_ lineLength: Int = 30, _ lineSpacing: Int = 2, _ lineColor: UIColor = UIColor.gray) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = base.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = lineColor.cgColor

        shapeLayer.lineWidth = base.frame.size.height
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round

        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]

        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: base.frame.size.width, y: 0))

        shapeLayer.path = path
        base.layer.addSublayer(shapeLayer)
    }
}

public extension IntegerLiteralType {
    var f: CGFloat {
        return CGFloat(self)
    }
}

public extension Float {
    var f: CGFloat {
        return CGFloat(self)
    }
}

public extension FloatLiteralType {
    var f: CGFloat {
        return CGFloat(self)
    }
}

extension UIEdgeInsets {
    public static func all(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: side, bottom: side, right: side)
    }

    init(hAxis: CGFloat = 0, vAxis: CGFloat = 0) {
        self.init(top: vAxis, left: hAxis, bottom: vAxis, right: hAxis)
    }

    static func left(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: value, bottom: 0, right: 0)
    }

    static func right(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: value)
    }

    static func top(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: value, left: 0, bottom: 0, right: 0)
    }

    static func bottom(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: value, right: 0)
    }
}

extension GFCompat where Base: UILabel {
    func setTextColor(textColor: UIColor, font: UIFont, _ alignment: NSTextAlignment = .center) {
        base.textColor = textColor
        base.font = font
        base.textAlignment = alignment
    }

    func setText(text: String, textColor: UIColor, font: UIFont, _ alignment: NSTextAlignment = .center) {
        base.text = text
        base.textColor = textColor
        base.font = font
        base.textAlignment = alignment
    }
}

extension GFCompat where Base: UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let c = UIGraphicsGetCurrentContext() {
            c.setFillColor(color.cgColor)
            c.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        base.setBackgroundImage(colorImage, for: forState)
    }
}

extension GFCompat where Base: UIViewController {
    // iOS scrollview 及其子类带有导航栏时自动调整内边距问题
    func adjustScrollContentInset(_ scrollView: UIScrollView?) {
        if #available(iOS 11.0, *) {
            scrollView?.contentInsetAdjustmentBehavior = .never
        } else {
            base.automaticallyAdjustsScrollViewInsets = false
        }
    }
}

/// 水印添加
extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    convenience init(view: UIView, scale: CGFloat) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        defer { UIGraphicsEndImageContext() }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

extension GFCompat where Base: UIImage {
    /// Add WaterMarkingImage
    ///
    /// - Parameters:
    ///   - image: the image that painted on
    ///   - waterImageName: waterImage
    /// - Returns: the warterMarked image
    static func waterMarkingImage(image: UIImage, with waterImage: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        let waterImageX = image.size.width * 0.78
        let waterImageY = image.size.height - image.size.width / 5.4
        let waterImageW = image.size.width * 0.2
        let waterImageH = image.size.width * 0.075
        waterImage.draw(in: CGRect(x: waterImageX, y: waterImageY, width: waterImageW, height: waterImageH))

        let waterMarkingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return waterMarkingImage
    }

    /// Add WaterMarking Text
    ///
    /// - Parameters:
    ///   - image: the image that painted on
    ///   - text: the text that needs painted
    /// - Returns: the waterMarked image
    static func waterMarkingImage(image: UIImage, with text: String) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        let str = text as NSString
        let pointY = image.size.height - image.size.width * 0.1
        let point = CGPoint(x: image.size.width * 0.78, y: pointY)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8),
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: image.size.width / 25.0)] as [NSAttributedString.Key: Any]
        str.draw(at: point, withAttributes: attributes)

        let waterMarkingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return waterMarkingImage
    }

    func transform(withNewColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)

        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: base.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        context.clip(to: rect, mask: base.cgImage!)

        color.setFill()
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    public func roundCorners(_ cornerRadius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        let rect = CGRect(origin: CGPoint.zero, size: base.size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

        context?.beginPath()
        context?.addPath(path.cgPath)
        context?.closePath()
        context?.clip()

        base.draw(at: CGPoint.zero)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func crop(ratio: CGFloat) -> UIImage { // 将图片裁剪成指定比例（多余部分自动删除）
        // 计算最终尺寸
        var newSize: CGSize!
        if base.size.width / base.size.height > ratio {
            newSize = CGSize(width: base.size.height * ratio, height: base.size.height)
        } else {
            newSize = CGSize(width: base.size.width, height: base.size.width / ratio)
        }

        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width = base.size.width
        rect.size.height = base.size.height
        rect.origin.x = (newSize.width - base.size.width) / 2.0
        rect.origin.y = (newSize.height - base.size.height) / 2.0

        // 绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        base.draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
    }

    func scale(to newSize: CGSize) -> UIImage { // 将图片缩放成指定尺寸（多余部分自动删除）
        // 计算比例
        let aspectWidth = newSize.width / base.size.width
        let aspectHeight = newSize.height / base.size.height
        let aspectRatio = max(aspectWidth, aspectHeight)

        // 图片绘制区域
        var scaledImageRect = CGRect.zero
        scaledImageRect.size.width = base.size.width * aspectRatio
        scaledImageRect.size.height = base.size.height * aspectRatio
        scaledImageRect.origin.x = (newSize.width - base.size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y = (newSize.height - base.size.height * aspectRatio) / 2.0

        // 绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        base.draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
    }
}

extension UIColor {
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.hasPrefix("0x") {
            cString.removeFirst(2)
        }

        if cString.count != 6 {
            self.init(white: 1, alpha: 1)
            return
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension GFCompat where Base: UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0 ... 255) / 255.0, green: CGFloat.random(in: 0 ... 255) / 255.0, blue: CGFloat.random(in: 0 ... 255) / 255.0, alpha: 1.0)
    }
}

extension CGFloat {
    /// 视图中所有水平值都是宽度为375时设定的逻辑值，这里返回实际的水平方向上的值
    var real: CGFloat {
        return (self * UIScreen.gf.screenWidth) / 375.0
    }

    /// 返回该数值在刘海影响下的数值
    var realTop: CGFloat {
        if #available(iOS 11.0, *), let top = UIApplication.shared.keyWindow?.safeAreaInsets.top, top != 0 {
            return self.real + top
        } else {
            // Fallback on earlier versions
            return real
        }
    }

    var realBottom: CGFloat {
        if #available(iOS 11.0, *), let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom, bottom != 0 {
            return self.real + bottom
        } else {
            // Fallback on earlier versions
            return real
        }
    }
}

extension GFCompat where Base: UIScrollView {
    func scrollToTop() {
        base.gf.scrollToTopAnimated(true)
    }

    func scrollToBottom() {
        base.gf.scrollToBottomAnimated(true)
    }

    func scrollToLeft() {
        base.gf.scrollToLeftAnimated(true)
    }

    func scrollToRight() {
        base.gf.scrollToRightAnimated(true)
    }

    func scrollToTopAnimated(_ animated: Bool) {
        var off = base.contentOffset
        off.y = 0 - base.contentInset.top
        base.setContentOffset(off, animated: animated)
    }

    func scrollToBottomAnimated(_ animated: Bool) {
        var off = base.contentOffset
        off.y = base.contentSize.height - base.bounds.size.height + base.contentInset.bottom
        base.setContentOffset(off, animated: animated)
    }

    func scrollToLeftAnimated(_ animated: Bool) {
        var off = base.contentOffset
        off.x = 0 - base.contentInset.left
        base.setContentOffset(off, animated: animated)
    }

    func scrollToRightAnimated(_ animated: Bool) {
        var off = base.contentOffset
        off.x = base.contentSize.width - base.bounds.size.width + base.contentInset.right
        base.setContentOffset(off, animated: animated)
    }
}

extension GFCompat where Base: UITableView {
    func scrollToRow(_ row: Int, in section: Int, atScrollPosition position: UITableView.ScrollPosition, _ animated: Bool) {
        let indexpath = IndexPath(row: row, section: section)
        base.scrollToRow(at: indexpath, at: position, animated: animated)
    }

    func insertRow(at indexPath: IndexPath, withRowAnimation animation: UITableView.RowAnimation) {
        base.insertRows(at: [indexPath], with: animation)
    }

    func insertRow(_ row: Int, in section: Int, withRowAnimation animation: UITableView.RowAnimation) {
        let toInsert = IndexPath(row: row, section: section)
        base.gf.insertRow(at: toInsert, withRowAnimation: animation)
    }

    func reloadRow(at indexPath: IndexPath, withRowAnimation animation: UITableView.RowAnimation) {
        base.reloadRows(at: [indexPath], with: animation)
    }

    func reloadRow(_ row: Int, in section: Int, withRowAnimation animation: UITableView.RowAnimation) {
        let toReload = IndexPath(row: row, section: section)
        base.gf.reloadRow(at: toReload, withRowAnimation: animation)
    }

    func deleteRow(at _: IndexPath, withRowAnimation _: UITableView.RowAnimation) {}
}

enum LayoutStyle: Int {
    case imageTop
    case imageLeft
    case imageBottom
    case imageRight
}

extension GFCompat where Base: UIButton {
    func layoutButton(_ style: LayoutStyle, space: CGFloat) {
        guard let titleL = self.base.titleLabel, let imageV = self.base.imageView else {
            return
        }

        let imageWidth = imageV.frame.size.width
        let imageHeight = imageV.frame.size.height

        let labelWidth = titleL.frame.size.width
        let labelHeight = titleL.frame.size.height

        let imageX = imageV.frame.origin.x
        let labelX = titleL.frame.origin.x

        let margin = labelX - imageX - imageWidth

        var imageInsets = UIEdgeInsets.zero
        var labelInsets = UIEdgeInsets.zero

        /**
         *  titleEdgeInsets是title相对于其上下左右的inset
         *  如果只有title，那它上下左右都是相对于button的，image也是一样；
         *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
         */
        switch style {
        case .imageTop:
            imageInsets = UIEdgeInsets(top: -0.5 * labelHeight, left: 0.5 * labelWidth + 0.5 * margin + imageX, bottom: 0.5 * (labelHeight + space), right: 0.5 * (labelWidth - margin))
            labelInsets = UIEdgeInsets(top: 0.5 * (imageHeight + space), left: -(imageWidth - 5), bottom: -0.5 * imageHeight, right: 5)

        case .imageBottom:
            imageInsets = UIEdgeInsets(top: 0.5 * (labelHeight + space), left: 0.5 * labelWidth + imageX, bottom: -0.5 * labelHeight, right: 0.5 * labelWidth)
            labelInsets = UIEdgeInsets(top: -0.5 * imageHeight, left: -(imageWidth - 5), bottom: 0.5 * (imageHeight + space), right: 5)

        case .imageRight:
            imageInsets = UIEdgeInsets(top: 0, left: 0.5 * (labelWidth + space), bottom: 0, right: -(labelWidth + 0.5 * space))
            labelInsets = UIEdgeInsets(top: 0, left: -(imageWidth + 0.5 * space), bottom: 0, right: imageWidth + space * 0.5)

        default:
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0.5 * space)
            labelInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: 0)
        }

        base.titleEdgeInsets = labelInsets
        base.imageEdgeInsets = imageInsets
    }
}

// MARK: - UIGestureRecognizer

extension UIGestureRecognizer {
    @discardableResult convenience init(addToView targetView: UIView,
                                        closure: @escaping (UIGestureRecognizer) -> Void) {
        self.init()

        GestureTarget.add(gesture: self,
                          closure: closure,
                          toView: targetView)
    }
}

private class GestureTarget: UIView {
    class ClosureContainer {
        weak var gesture: UIGestureRecognizer?
        let closure: (UIGestureRecognizer) -> Void

        init(closure: @escaping (UIGestureRecognizer) -> Void) {
            self.closure = closure
        }
    }

    var containers = [ClosureContainer]()

    convenience init() {
        self.init(frame: .zero)
        isHidden = true
    }

    class func add(gesture: UIGestureRecognizer, closure: @escaping (UIGestureRecognizer) -> Void,
                   toView targetView: UIView) {
        let target: GestureTarget
        if let existingTarget = existingTarget(inTargetView: targetView) {
            target = existingTarget
        } else {
            target = GestureTarget()
            targetView.addSubview(target)
        }
        let container = ClosureContainer(closure: closure)
        container.gesture = gesture
        target.containers.append(container)

        gesture.addTarget(target, action: #selector(GestureTarget.target(gesture:)))
        targetView.addGestureRecognizer(gesture)
    }

    class func existingTarget(inTargetView targetView: UIView) -> GestureTarget? {
        for subview in targetView.subviews {
            if let target = subview as? GestureTarget {
                return target
            }
        }
        return nil
    }

    func cleanUpContainers() {
        containers = containers.filter { $0.gesture != nil }
    }

    @objc func target(gesture: UIGestureRecognizer) {
        cleanUpContainers()

        for container in containers {
            guard let containerGesture = container.gesture else {
                continue
            }

            if gesture === containerGesture {
                container.closure(gesture)
            }
        }
    }
}

extension GFCompat where Base: UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPod5,1": return "iPod Touch 5"
        case "iPod7,1": return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1": return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2": return "iPhone 5"
        case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone9,1": return "iPhone 7 (CDMA)"
        case "iPhone9,3": return "iPhone 7 (GSM)"
        case "iPhone9,2": return "iPhone 7 Plus (CDMA)"
        case "iPhone9,4": return "iPhone 7 Plus (GSM)"
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus (GSM)"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,8": return "iPhone XR"
        case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"

        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
        case "iPad5,1", "iPad5,2": return "iPad Mini 4"
        case "iPad6,7", "iPad6,8": return "iPad Pro"
        case "AppleTV5,3": return "Apple TV"
        case "i386", "x86_64": return "Simulator"
        default: return identifier
        }
    }

    /// 检查系统语言是否变动
    ///
    /// - Returns: ture 变动,false 未变动
    func langChanged() -> Bool {
        guard let currentLanguage = NSLocale.preferredLanguages.first else {
            return false
        }
        if let preLanguage = UserDefaults.standard.object(forKey: "localLanguage") as? String {
            if preLanguage != currentLanguage {
                UserDefaults.standard.set(currentLanguage, forKey: "localLanguage")
                return true
            } else {
                return false
            }
        } else {
            UserDefaults.standard.set(currentLanguage, forKey: "localLanguage")
            return false
        }
    }
}

protocol UITableViewCellDataSource {
    associatedtype T
    func setData<T>(_ data: T)
}

/// 环境参数，影响上传和服务器连接
class NetEnviroment: NSObject {
    let baseUrl: URL
    let bucket: String
    let replacementUrl: String?
    let name: String
    let h5Url: String
    let baseUrlStr: String

    init(baseUrlString: String, bucket: String, replacementUrl: String?,
         name: String, h5Url: String, emchatApnName _: String) {
        baseUrlStr = baseUrlString
        baseUrl = URL(string: baseUrlString)!
        self.bucket = bucket
        self.replacementUrl = replacementUrl
        self.name = name
        self.h5Url = h5Url
    }

    var isProductEnvironment: Bool {
        return bucket == "hltravel"
    }

    static var testServer: NetEnviroment {
        return NetEnviroment(baseUrlString: "http://10.0.0.252:8092",
                             bucket: "hltext",
                             replacementUrl: nil,
                             name: "测试环境(内)",
                             h5Url: "http://testwap.honglelx.com",
                             emchatApnName: "商家版开发证书")
    }

    static var productServer: NetEnviroment {
        return NetEnviroment(baseUrlString: "http://supplier.honglelx.com",
                             bucket: "hltravel",
                             replacementUrl: "img.honglelx.com/",
                             name: "正式环境",
                             h5Url: "https://wap.honglelx.com",
                             emchatApnName: "商家版正式证书")
    }

    static var enviroments = [NetEnviroment.productServer,
                              NetEnviroment.testServer]
}

extension GFCompat where Base: UserDefaults {
    enum UserDataKeys: String {
        case userid
        case userToken
        case userName
        case userIcon
        case telephone
        case status
        case type
        case account
        case appstoreVersion // 苹果商店版本号，用于启动页
        case serverVersion // 软件版本号，用于更新提示
        case netEnviroment // 当前接口环境
        case userAlias // 最后一次设置的别名
    }

    static var account: String {
        set {
            Base.standard.set(newValue, forKey: UserDataKeys.account.rawValue)
        }
        get {
            return Base.standard.string(forKey: UserDataKeys.account.rawValue) ?? ""
        }
    }

    static var status: String {
        set {
            Base.standard.set(newValue, forKey: UserDataKeys.status.rawValue)
        }
        get {
            return Base.standard.string(forKey: UserDataKeys.status.rawValue) ?? ""
        }
    }

    static var type: Int {
        set {
            Base.standard.set(newValue, forKey: UserDataKeys.type.rawValue)
        }
        get {
            return Base.standard.integer(forKey: UserDataKeys.type.rawValue)
        }
    }

    static var telephone: String {
        set {
            Base.standard.set(newValue, forKey: UserDataKeys.telephone.rawValue)
        }
        get {
            return Base.standard.string(forKey: UserDataKeys.telephone.rawValue) ?? ""
        }
    }

    static var userName: String {
        set {
            Base.standard.set(newValue, forKey: UserDataKeys.userName.rawValue)
        }
        get {
            return Base.standard.string(forKey: UserDataKeys.userName.rawValue) ?? ""
        }
    }

    static var userId: Int {
        set {
            Base.standard.set(newValue, forKey: UserDataKeys.userid.rawValue)
        }
        get {
            return Base.standard.integer(forKey: UserDataKeys.userid.rawValue)
        }
    }

    static var userIcon: String {
        set {
            Base.standard.set(newValue, forKey: UserDataKeys.userIcon.rawValue)
        }
        get {
            return Base.standard.string(forKey: UserDataKeys.userIcon.rawValue) ?? ""
        }
    }

    static var modelName: String {
        return UIDevice.current.gf.modelName
    }

    static var userToken: String {
        set {
            Base.standard.set(newValue, forKey: UserDataKeys.userToken.rawValue)
        }
        get {
            return Base.standard.string(forKey: UserDataKeys.userToken.rawValue) ?? ""
        }
    }

    static var appstoreVersion: String? {
        set {
            Base.standard.set(newValue, forKey: UserDataKeys.appstoreVersion.rawValue)
        }
        get {
            return Base.standard.string(forKey: UserDataKeys.appstoreVersion.rawValue)
        }
    }

    static var serverVersion: String? {
        set {
            Base.standard.set(newValue, forKey: UserDataKeys.serverVersion.rawValue)
        }
        get {
            return Base.standard.string(forKey: UserDataKeys.serverVersion.rawValue)
        }
    }

    static var networkEnvIndex: Int {
        set {
            Base.standard.set(newValue, forKey: UserDataKeys.netEnviroment.rawValue)
        }
        get {
            return Base.standard.integer(forKey: UserDataKeys.netEnviroment.rawValue)
        }
    }

    static var serverVersionName: String {
        return "2.0"
    }

    static var serverVersionCode: String {
        return "2019080104"
    }

    static var sysData: [String: String] {
        return ["device-model": "1",
                "user-id": "\(UserDefaults.gf.userId)",
                "mac": UIDevice.current.identifierForVendor?.uuidString ?? "N/A",
                "imei": "",
                "token": UserDefaults.gf.userToken,
                "imsi": "",
                "os-name": "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)",
                "phone-model": UIDevice.current.gf.modelName,
                "version-code": serverVersionCode,
                "version-name": serverVersionName]
    }

//    static func setUser(_ data: UserData) {
//        UserDefaults.gf.userId = data.userId
//        UserDefaults.gf.userToken = data.sessionToken
//        UserDefaults.gf.telephone = data.mobile
//        UserDefaults.gf.userIcon = data.userIcon
//        UserDefaults.gf.userName = data.userName
//        UserDefaults.gf.telephone = data.mobile
//        UserDefaults.gf.account = data.account
//        UserDefaults.gf.status = data.status
//        UserDefaults.gf.type = data.type
//    }

    static func clearUser() {
        UserDefaults.gf.userId = 0
        UserDefaults.gf.userToken = ""
        UserDefaults.gf.telephone = ""
        UserDefaults.gf.userIcon = ""
        UserDefaults.gf.userName = ""
        UserDefaults.gf.telephone = ""
        UserDefaults.gf.account = ""
        UserDefaults.gf.status = ""
        UserDefaults.gf.type = 0
//        JPUSHConfig.instance.signoutAlias() // jpush退出alias
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    static func firstLaunch() -> Bool { // 应用第一次启动
        let hasBeenLaunched = "hasBeenLaunched"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunched)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunched)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }

    static func versionFirstLaunch() -> Bool { // 当前版本第一次启动
        // 主程序版本号
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"] as! String

        // 上次启动的版本号
        let hasBeenLaunchedOfNewVersion = "hasBeenLaunchedOfNewVersion"
        let lastLaunchVersion = UserDefaults.standard.string(forKey:
            hasBeenLaunchedOfNewVersion)

        // 版本号比较
        let isFirstLaunchOfNewVersion = majorVersion != lastLaunchVersion
        if isFirstLaunchOfNewVersion {
            UserDefaults.standard.set(majorVersion, forKey:
                hasBeenLaunchedOfNewVersion)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunchOfNewVersion
    }
}

// MARK: UIButton UIImageView 扩大点击响应区域 (重写point inside 方法)
private func associatedObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, initialiser: () -> ValueType) -> ValueType {
    if let associated = objc_getAssociatedObject(base, key) as? ValueType { return associated }

    let associated = initialiser()

    objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)

    return associated
}

private func associateObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType) {
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}

private func swizzleMethod(cls: AnyClass?, ori: Selector, new: Selector) {
    guard let oriMethod = class_getInstanceMethod(cls, ori) else {return}
    guard let newMethod = class_getInstanceMethod(cls, new) else {return}
    if class_addMethod(cls, ori, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) {
        class_replaceMethod(cls, new, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
    } else {
        method_exchangeImplementations(oriMethod, newMethod)
    }
}

extension UIButton : UIViewEnlarge {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = enlargedRect()
        
        if rect.equalTo(bounds) { return super.point(inside: point, with: event) }
        
        return rect.contains(point) ? true : false
    }
}
extension UIImageView : UIViewEnlarge {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = enlargedRect()
        
        if rect.equalTo(bounds) { return super.point(inside: point, with: event) }
        
        return rect.contains(point) ? true : false
    }
}

private var topKey: UInt8 = 0
private var bottomKey: UInt8 = 0
private var leftKey: UInt8 = 0
private var rightKey: UInt8 = 0

protocol UIViewEnlarge: UIView {}
extension UIViewEnlarge {
    var top: NSNumber {
        get { return associatedObject(base: self, key: &topKey) { 0 } }
        set { associateObject(base: self, key: &topKey, value: newValue) }
    }

    var bottom: NSNumber {
        get { return associatedObject(base: self, key: &bottomKey) { 0 } }
        set { associateObject(base: self, key: &bottomKey, value: newValue) }
    }

    var left: NSNumber {
        get { return associatedObject(base: self, key: &leftKey) { 0 } }
        set { associateObject(base: self, key: &leftKey, value: newValue) }
    }

    var right: NSNumber {
        get { return associatedObject(base: self, key: &rightKey) { 0 } }
        set { associateObject(base: self, key: &rightKey, value: newValue) }
    }

    func setEnlargeEdge(_ inset: UIEdgeInsets) {
        setEnlargeEdge(top: Float(inset.top), bottom: Float(inset.bottom), left: Float(inset.left), right: Float(inset.right))
    }

    func setEnlargeEdge(top: Float, bottom: Float, left: Float, right: Float) {
        self.top = NSNumber(value: top)
        self.left = NSNumber(value: left)
        self.right = NSNumber(value: right)
        self.bottom = NSNumber(value: bottom)
    }
    func setEnlargeEdge(_ surround: Float){
        self.top = NSNumber(value: surround)
        self.left = NSNumber(value: surround)
        self.right = NSNumber(value: surround)
        self.bottom = NSNumber(value: surround)
    }

    func enlargedRect() -> CGRect {
        let top = self.top
        let bottom = self.bottom
        let left = self.left
        let right = self.right

        if top.floatValue >= 0, bottom.floatValue >= 0, left.floatValue >= 0, right.floatValue >= 0 {
            return CGRect(
                x: bounds.origin.x - CGFloat(left.floatValue),
                y: bounds.origin.y - CGFloat(top.floatValue),
                width: bounds.size.width + CGFloat(left.floatValue) + CGFloat(right.floatValue),
                height: bounds.size.height + CGFloat(top.floatValue) + CGFloat(bottom.floatValue)
            )
        } else {
            return bounds
        }
    }
}

extension String {
    func boundingRect(with size: CGSize, attributes: [NSAttributedString.Key: Any]) -> CGRect {
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let rect = self.boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return UIView.gf.snap(rect)
    }

    func size(thatFits size: CGSize, font: UIFont, maximumNumberOfLines: Int = 0) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        var size = self.boundingRect(with: size, attributes: attributes).size
        if maximumNumberOfLines > 0 {
            size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
        }
        return size
    }

    func width(with font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        return self.size(thatFits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).width
    }

    func height(thatFitsWidth width: CGFloat, font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return self.size(thatFits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).height
    }
}

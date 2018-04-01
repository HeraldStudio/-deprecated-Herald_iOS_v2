//
//  SnapKit.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/10/2017.
//  Copyright © 2017 Vhyme. All rights reserved.
//

import UIKit
import SnapKit

/// 当前父控件上下文
fileprivate var lastContainer: UIView?

extension UIView {
    
    /// 添加到某个父控件
    @discardableResult func into(_ superview: UIView? = nil) -> Self {
        var superview = superview
        if superview == nil {
            superview = lastContainer
        }
        if let superview = superview, self.superview != superview {
            self.removeFromSuperview()
            superview.addSubview(self)
        }
        return self
    }
    
    fileprivate func autoCheckInto() {
        if superview == nil {
            into()
        }
    }
    
    /// 清除自身的约束
    @discardableResult func remake() -> Self {
        autoCheckInto()
        self.snp.removeConstraints()
        return self
    }
    
    /// 令宽度等于常数
    @discardableResult func width(_ const: CGFloat) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.width.equalTo(const)
        }
        return self
    }
    
    /// 令高度等于常数
    @discardableResult func height(_ const: CGFloat) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.height.equalTo(const)
        }
        return self
    }
    
    /// 令宽度、高度等于 CGSize
    @discardableResult func size(_ size: CGSize) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.width.equalTo(size.width)
            $0.height.equalTo(size.height)
        }
        return self
    }
    
    /// 令宽高比等于常数
    @discardableResult func ratio(_ const: CGFloat) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.width.equalTo(self.snp.height).multipliedBy(const)
        }
        return self
    }
    
    /// 令左边与另一控件左边对齐，可指定偏移，右移为正，左移为负
    @discardableResult func left(_ view: UIView, _ offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.left.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 令右边与另一控件右边对齐，可指定偏移，右移为正，左移为负
    @discardableResult func right(_ view: UIView, _ offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.right.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 令上边与另一控件上边对齐，可指定偏移，下移为正，上移为负
    @discardableResult func top(_ view: UIView, _ offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.top.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 令下边与另一控件下边对齐，可指定偏移，下移为正，上移为负
    @discardableResult func bottom(_ view: UIView, _ offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 令宽度与另一控件相等，可指定比例系数
    @discardableResult func width(_ view: UIView, multiplier: CGFloat = 1, offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.width.equalTo(view).multipliedBy(multiplier).offset(offset)
        }
        return self
    }
    
    /// 令高度与另一控件相等，可指定比例系数
    @discardableResult func height(_ view: UIView, multiplier: CGFloat = 1, offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.height.equalTo(view).multipliedBy(multiplier).offset(offset)
        }
        return self
    }
    
    /// 与另一控件左右居中对齐，可指定偏移，右移为正，左移为负
    @discardableResult func centerX(_ view: UIView, _ offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.centerX.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 与另一控件上下居中对齐，可指定偏移，下移为正，上移为负
    @discardableResult func centerY(_ view: UIView, _ offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.centerY.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 紧接在另一控件右侧，可指定间距
    @discardableResult func after(_ view: UIView, _ spacing: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.left.equalTo(view.snp.right).offset(spacing)
        }
        return self
    }
    
    /// 紧接在另一控件左侧，可指定间距
    @discardableResult func before(_ view: UIView, _ spacing: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.right.equalTo(view.snp.left).offset(-spacing)
        }
        return self
    }
    
    /// 紧接在另一控件下方，可指定间距
    @discardableResult func below(_ view: UIView, _ spacing: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom).offset(spacing)
        }
        return self
    }
    
    /// 紧接在另一控件上方，可指定间距
    @discardableResult func above(_ view: UIView, _ spacing: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.top).offset(-spacing)
        }
        return self
    }
    
    /// 添加子控件
    @discardableResult func with(_ closure: () -> Void) -> Self {
        autoCheckInto()
        let oldLastContainer = lastContainer
        lastContainer = self
        closure()
        lastContainer = oldLastContainer
        return self
    }
    
    @discardableResult func tap(_ closure: @escaping () -> Void) -> Self {
        autoCheckInto()
        //        self.setOnTap(closure)
        return self
    }
    
    @discardableResult func dest(_ closure: @escaping () -> UIViewController) -> Self {
        autoCheckInto()
        //        self.setDestination(closure)
        return self
    }
}

extension UIView {
    
    /// 令左边贴紧父控件，可指定边距
    @discardableResult func left(_ inset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.left.equalToSuperview().offset(inset)
        }
        return self
    }
    
    /// 令右边贴紧父控件，可指定边距
    @discardableResult func right(_ inset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-inset)
        }
        return self
    }
    
    /// 令上边贴紧父控件，可指定边距
    @discardableResult func top(_ inset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.top.equalToSuperview().offset(inset)
        }
        return self
    }
    
    /// 令下边贴紧父控件，可指定边距
    @discardableResult func bottom(_ inset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-inset)
        }
        return self
    }
    
    /// 令四边贴紧父控件，可指定边距
    @discardableResult func fill(_ inset: UIEdgeInsets? = nil) -> Self {
        autoCheckInto()
        let inset = inset ?? UIEdgeInsets.zero
        self.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(inset)
        }
        return self
    }
    
    /// 令宽度等于父控件宽度
    @discardableResult func width(multiplier: CGFloat = 1, offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(multiplier).offset(offset)
        }
        return self
    }
    
    /// 令高度等于父控件高度
    @discardableResult func height(multiplier: CGFloat = 1, offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(multiplier).offset(offset)
        }
        return self
    }
    
    /// 与父控件左右居中对齐，可指定偏移，右移为正，左移为负
    @discardableResult func centerX(_ offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(offset)
        }
        return self
    }
    
    /// 与父控件上下居中对齐，可指定偏移，下移为正，上移为负
    @discardableResult func centerY(_ offset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(offset)
        }
        return self
    }
    
    /// 与父控件居中对齐，可指定偏移，右下移为正，左上移为负
    @discardableResult func center(_ offsetX: CGFloat = 0, _ offsetY: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(offsetX)
            $0.centerY.equalToSuperview().offset(offsetY)
        }
        return self
    }
    
    /// 向上撑起父控件，即令控件上边至少在父控件上边的下方
    @discardableResult func inflateUp(_ inset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().offset(inset)
        }
        return self
    }
    
    /// 向上撑起父控件，即令控件下边至少在父控件下边的上方
    @discardableResult func inflateDown(_ inset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.bottom.lessThanOrEqualToSuperview().offset(-inset)
        }
        return self
    }
    
    /// 向左撑起父控件，即令控件左边至少在父控件左边的右方
    @discardableResult func inflateLeft(_ inset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.left.greaterThanOrEqualToSuperview().offset(inset)
        }
        return self
    }
    
    /// 向右撑起父控件，即令控件右边至少在父控件右边的左方
    @discardableResult func inflateRight(_ inset: CGFloat = 0) -> Self {
        autoCheckInto()
        self.snp.makeConstraints {
            $0.right.lessThanOrEqualToSuperview().offset(-inset)
        }
        return self
    }
    
    /// 自动向下排列，即自动寻找父控件中上一个控件，紧贴在其下方，并自动向下撑起父控件
    @discardableResult func flowDown(_ spacing: CGFloat = 0) -> Self {
        autoCheckInto()
        let lastView = superview?.subviews.filter { $0 != self }.last
        if let lastView = lastView {
            below(lastView, spacing)
        } else {
            top()
        }
        inflateDown()
        return self
    }
    
    /// 自动向右排列，即自动寻找父控件中上一个控件，紧贴在其右方，并自动向右撑起父控件
    @discardableResult func flowRight(_ spacing: CGFloat = 0) -> Self {
        autoCheckInto()
        let lastView = superview?.subviews.filter { $0 != self }.last
        if let lastView = lastView {
            after(lastView, spacing)
        } else {
            left()
        }
        inflateRight()
        
        return self
    }
}

extension UIView {
    /// 背景颜色
    @discardableResult func background(_ color: UIColor) -> Self {
        autoCheckInto()
        self.backgroundColor = color
        return self
    }
    /// 设置contentMode
    @discardableResult func mode(_ mode: UIViewContentMode) -> Self {
        autoCheckInto()
        self.contentMode = mode
        return self
    }
    
    @discardableResult func round(_ radius: CGFloat) -> Self {
        autoCheckInto()
        self.layer.cornerRadius = radius
        self.clipsToBounds = radius > 0.1
        return self
    }
    
    @discardableResult func border(_ width: CGFloat, _ color: UIColor) -> Self {
        autoCheckInto()
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult func shadow(_ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), _ opacity: CGFloat = 0.1) -> Self {
        autoCheckInto()
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = r
        self.layer.shadowOpacity = Float(opacity)
        return self
    }
    
    @discardableResult func tint(_ color: UIColor) -> Self {
        autoCheckInto()
        self.tintColor = color
        return self
    }
    
    /// 设置 clipsToBounds
    @discardableResult func clip(_ flag: Bool) -> Self {
        autoCheckInto()
        self.clipsToBounds = flag
        return self
    }
}

fileprivate let weights = [
    UIFontWeightUltraLight,
    UIFontWeightThin,
    UIFontWeightLight,
    UIFontWeightRegular,
    UIFontWeightMedium,
    UIFontWeightSemibold,
    UIFontWeightBold,
    UIFontWeightHeavy,
    UIFontWeightBlack
]

enum FontWeight: Int {
    case ultralight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black
}

extension UILabel {
    
    @discardableResult func text(_ text: String = "") -> Self {
        autoCheckInto()
        self.text = text
        return self
    }
    
    @discardableResult func color(_ color: UIColor) -> Self {
        autoCheckInto()
        self.textColor = color
        return self
    }
    
    @discardableResult func font(_ size: CGFloat, _ weight: FontWeight = .regular) -> Self {
        autoCheckInto()
        self.font = UIFont.systemFont(ofSize: size, weight: weights[weight.rawValue])
        return self
    }
    
    @discardableResult func align(_ align: NSTextAlignment) -> Self {
        autoCheckInto()
        self.textAlignment = align
        return self
    }
    
    @discardableResult func lines(_ lines: Int) -> Self {
        autoCheckInto()
        self.numberOfLines = lines
        return self
    }
    
    //设置lineBreakMode
    @discardableResult func breakMode(_ breakMode: NSLineBreakMode) -> Self {
        autoCheckInto()
        self.lineBreakMode = breakMode
        return self
    }
    
    @discardableResult func spacing(_ spacing: CGFloat) -> Self {
        autoCheckInto()
        let attrs = NSMutableAttributedString(attributedString: self.attributedText ?? NSAttributedString(string: self.text ?? ""))
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attrs.addAttributes([NSParagraphStyleAttributeName: style], range: NSRange(location: 0, length: attrs.length))
        self.attributedText = attrs
        return self
    }
}

fileprivate let borderStyles = [
    UITextBorderStyle.bezel,
    UITextBorderStyle.line,
    UITextBorderStyle.none,
    UITextBorderStyle.roundedRect
]

enum borderStyle: Int {
    case bezel
    case line
    case none
    case roundedRect
}

extension UITextField {
    
    @discardableResult func text(_ text: String = "") -> Self {
        autoCheckInto()
        self.text = text
        return self
    }
    
    @discardableResult func hint(_ hint: String = "") -> Self {
        autoCheckInto()
        self.placeholder = hint
        return self
    }
    
    @discardableResult func color(_ color: UIColor) -> Self {
        autoCheckInto()
        self.textColor = color
        return self
    }
    
    @discardableResult func font(_ size: CGFloat, _ weight: FontWeight = .regular) -> Self {
        autoCheckInto()
        self.font = UIFont.systemFont(ofSize: size, weight: weights[weight.rawValue])
        return self
    }
    
    @discardableResult func align(_ align: NSTextAlignment) -> Self {
        autoCheckInto()
        self.textAlignment = align
        return self
    }
    
    @discardableResult func placeholder(_ text: String = "") -> Self {
        autoCheckInto()
        self.placeholder = text
        return self
    }
    
    @discardableResult func borderStyle(_ style: borderStyle = .roundedRect) -> Self {
        autoCheckInto()
        self.borderStyle = borderStyles[style.rawValue]
        return self
    }
    
    @discardableResult func isSecureText(_ flag: Bool = true) -> Self {
        autoCheckInto()
        self.isSecureTextEntry = flag
        return self
    }
}

extension UIButton {
    @discardableResult func title(_ title: String, _ state: UIControlState = .normal) -> Self {
        autoCheckInto()
        self.setTitle(title,for: state)
        return self
    }
    
    @discardableResult func color(_ color: UIColor, _ state: UIControlState = .normal) -> Self{
        autoCheckInto()
        self.setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult func numberOfLines(_ lines: Int = 0) -> Self{
        autoCheckInto()
        self.titleLabel?.numberOfLines = lines
        return self
    }
    
    @discardableResult func align(_ align: NSTextAlignment) -> Self {
        autoCheckInto()
        self.titleLabel?.textAlignment = align
        return self
    }
    
    @discardableResult func contentAlign(_ align: UIControlContentHorizontalAlignment ) -> Self {
        autoCheckInto()
        self.contentHorizontalAlignment = align
        return self
    }
}

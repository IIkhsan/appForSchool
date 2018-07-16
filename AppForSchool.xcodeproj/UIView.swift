//
//  UIViewExtensions.swift
//  Evo
//
//  Created by Ленар Гилязов on 16.01.18.
//  Copyright © 2018 Evo. All rights reserved.
//

import UIKit

extension UIView {
    
    //MARK: - Размеры
    
    var size: CGSize {
        set (value) {self.frame.size = value}
        get         {return self.frame.size}
    }
    
    var width: CGFloat {
        set (value) {self.size = CGSize(width: value, height: frame.size.height)}
        get         {return self.frame.size.width}
    }
    
    var height: CGFloat {
        set (value) {self.size = CGSize(width: frame.size.width, height: value)}
        get         {return self.frame.size.height}
    }
    
    //MARK: - Положение
    
    var origin: CGPoint {
        set (value) {self.frame.origin = value}
        get         {return self.frame.origin}
    }
    
    var x: CGFloat {
        set (value) {self.origin = CGPoint(x: value, y: frame.origin.y)}
        get         {return self.frame.origin.x}
    }
    
    var y: CGFloat {
        set (value) {self.origin = CGPoint(x: frame.origin.x, y: value)}
        get         {return self.frame.origin.y}
    }
    
    //MARK: - Остальное
    
    func findAndResignFirstResponder () -> Bool {
        if self.isFirstResponder {
            self.resignFirstResponder()
            return true
        }
        
        for view in subviews {
            if view.findAndResignFirstResponder() {
                return true
            }
        }
        
        return false
    }
    
    var allSubviews: [UIView] {
        var arr:[UIView] = [self]
        
        for view in subviews {
            arr += view.allSubviews
        }
        
        return arr
    }
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
}

//MARK: - Extensions for Storyboard
public extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set(newValue) { self.layer.cornerRadius = newValue }
        get { return self.layer.cornerRadius }
    }
    
    @IBInspectable var borderColor: UIColor {
        set(newValue) { self.layer.borderColor = newValue.cgColor }
        get { return UIColor(cgColor: self.layer.borderColor!) }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set(newValue) { self.layer.borderWidth = newValue }
        get { return self.layer.borderWidth }
    }
    
    @IBInspectable var shadowColor: UIColor {
        set(newValue) { self.layer.shadowColor = newValue.cgColor }
        get { return UIColor(cgColor: self.layer.shadowColor!) }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set(newValue) { self.layer.shadowOffset = newValue }
        get { return  self.layer.shadowOffset}
    }
    
    @IBInspectable var shadowOpacity: Float {
        set(newValue) { self.layer.shadowOpacity = newValue }
        get { return  self.layer.shadowOpacity}
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set(newValue) { self.layer.shadowRadius = newValue }
        get { return  self.layer.shadowRadius}
    }
    
    @IBInspectable var masksToBounds: Bool {
        set(newValue) { self.layer.masksToBounds = newValue }
        get { return self.layer.masksToBounds }
    }
    
}

//MARK: - Constraint Remove
extension UIView {
    func removeAllConstraints() {
        self.removeConstraints(constraints)
    }
    
    func removeConstraint(by identifier: String) {
        let c = constraints.filter {$0.identifier == identifier}
        guard let lc = c.first else { return }
        self.removeConstraint(lc)
    }
    func getConstraint(by identifier: String) -> NSLayoutConstraint? {
        let c = constraints.filter {$0.identifier == identifier}
        return c.first
    }
}

//MARK: - Форматирование кнопок фильтрации
extension UIView {
    //MARK: - Радиус на определенный угол
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    //MARK: - Border на отдельную сторону
    func addTopBorder(_ color: UIColor, width: CGFloat, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.width,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.width,
                                                multiplier: 1, constant: width))
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.height,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.height,
                                                multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.top,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.top,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.centerX,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.centerX,
                                              multiplier: 1, constant: 0))
        
    }
    
    func addBottomBorder(_ color: UIColor, width: CGFloat, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.width,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.width,
                                                multiplier: 1, constant: width))
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.height,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.height,
                                                multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.bottom,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.centerX,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.centerX,
                                              multiplier: 1, constant: 0))
    }
    func addLeftBorder(_ color: UIColor, width: CGFloat, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.width,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.width,
                                                multiplier: 1, constant: width))
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.height,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.height,
                                                multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.leading,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.leading,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.centerY,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.centerY,
                                              multiplier: 1, constant: 0))
    }
    func addRightBorder(_ color: UIColor, width: CGFloat, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.width,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.width,
                                                multiplier: 1, constant: width))
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.height,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.height,
                                                multiplier: 1, constant: height))
        
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.centerY,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.centerY,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.trailing,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.trailing,
                                              multiplier: 1, constant: 0))
    }
}

//
//  UtilFunction.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/05.
//

import UIKit

class UtilFunction {
    static func setGradient(baseView: UIView, _ firstColor: String, _ secondColor: String) {
        let gradient = CAGradientLayer()
        gradient.frame = baseView.bounds
        gradient.locations = [0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.colors = [
            hexStringToUIColor(hex: firstColor).cgColor,
            hexStringToUIColor(hex: secondColor).cgColor
        ]
        baseView.layer.insertSublayer(gradient, at: 0)
    }

    // hex 값을 color로 바꿔주는 코드
    static func hexStringToUIColor (hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

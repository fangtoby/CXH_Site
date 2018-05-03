//
//  BaseControl.swift
//  CXH_Salesman
//
//  Created by hao peng on 2017/4/7.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit

public func buildTxt(_ font:CGFloat,placeholder:String,tintColor:UIColor,keyboardType:UIKeyboardType) -> UITextField{
    let txt=UITextField()
    txt.font=UIFont.systemFont(ofSize: font)
    txt.attributedPlaceholder=NSAttributedString(string:placeholder, attributes: [NSAttributedStringKey.foregroundColor:UIColor.RGBFromHexColor("#999999")])
    txt.backgroundColor=UIColor.white
    txt.clearButtonMode=UITextFieldViewMode.whileEditing
    txt.tintColor=tintColor
    txt.textColor=tintColor
    txt.keyboardType=keyboardType
    return txt
}
/// 文本

public func buildLabel(_ textColor:UIColor,font:CGFloat,textAlignment:NSTextAlignment) -> UILabel{
        let lbl=UILabel()
        lbl.textColor=textColor
        lbl.font=UIFont.systemFont(ofSize: font)
        lbl.textAlignment=textAlignment
        return lbl
}

/// 按钮控件属性
public enum ButtonType {
    case button
    case cornerRadiusButton
}

/// 按钮
open class ButtonControl {
    
    open func button(_ type:ButtonType,text:String,textColor:UIColor,font:CGFloat,backgroundColor:UIColor,cornerRadius:CGFloat?) -> UIButton{
        switch type {
        case .button:
            return buildButton(text, textColor: textColor, font: font, backgroundColor: backgroundColor)
        case .cornerRadiusButton:
            return buildCornerRadiusButton(text,textColor:textColor,font:font,backgroundColor:backgroundColor,cornerRadius:cornerRadius!)
        }
    }
    
    fileprivate func buildCornerRadiusButton(_ text:String,textColor:UIColor,font:CGFloat,backgroundColor:UIColor,cornerRadius:CGFloat) -> UIButton{
        let btn=UIButton()
        btn.setTitle(text, for: UIControlState())
        btn.setTitleColor(textColor,for: UIControlState())
        btn.titleLabel!.font=UIFont.systemFont(ofSize: font)
        btn.backgroundColor=backgroundColor
        btn.layer.cornerRadius=cornerRadius
        return btn
    }
    fileprivate func buildButton(_ text:String,textColor:UIColor,font:CGFloat,backgroundColor:UIColor) -> UIButton{
        let btn=UIButton()
        btn.setTitle(text, for: UIControlState())
        btn.setTitleColor(textColor,for: UIControlState())
        btn.titleLabel!.font=UIFont.systemFont(ofSize: font)
        btn.backgroundColor=backgroundColor
        return btn
    }

    
}

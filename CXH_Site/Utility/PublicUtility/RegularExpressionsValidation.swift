//
//  RegularExpressionsValidation.swift
//  CCGC
//
//  Created by penghao on 16/12/19.
//  Copyright © 2016年 彭浩. All rights reserved.
//

import Foundation
//验证类型
enum ValidatedType {
    case email
    case phoneNumber
}
/// 正则表达式验证
class RegularExpressionsValidation{
    /// 共享实例
    static let sharedInstance = RegularExpressionsValidation()
    fileprivate init(){}
    fileprivate func ValidateText(validatedType type: ValidatedType, validateString: String) -> Bool {
        do {
            let pattern: String
            switch type{
            case .email:
                pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
                break
            case .phoneNumber:
                pattern = "^1[0-9]{10}$"
                break
            }
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
    /**
     验证邮箱
     
     - parameter vStr: 邮箱
     
     - returns: true是
     */
    func EmailIsValidated(_ vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.email, validateString: vStr)
    }
    /**
     验证手机号码
     
     - parameter vStr: 手机号码
     
     - returns: true是
     */
    func PhoneNumberIsValidated(_ vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.phoneNumber, validateString: vStr)
    }
}

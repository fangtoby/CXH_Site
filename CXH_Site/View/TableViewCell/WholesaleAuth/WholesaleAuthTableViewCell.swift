//
//  WholesaleAuthTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/9.
//  Copyright © 2018年 zltx. All rights reserved.
//

import UIKit
///批发授权
class WholesaleAuthTableViewCell: UITableViewCell {
    var operationMemberAuthStateClosure:(() -> Void)?
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var lblAccount:UILabel!
    @IBOutlet weak var btn:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.backgroundColor=UIColor.applicationMainColor()
        btn.layer.cornerRadius=15
        btn.addTarget(self, action:#selector(operationMemberAuthState), for:UIControlEvents.touchUpInside)
        self.selectionStyle = .none
    }
    func updateCell(entity:WholesaleAuthEntity){
        if entity.flag == 1{
            img.image=UIImage.init(named:"alredy_auth_icon")
            btn.setTitle("取消", for: UIControlState.normal)
        }else{
            img.image=UIImage.init(named:"canneled_auth_icon")
            btn.setTitle("授权", for: UIControlState.normal)
        }
        lblTime.text=entity.time
        lblAccount.text="授权会员:\(entity.account ?? "")"
    }
    ///操作授权会员状态
    @objc private func operationMemberAuthState(){
        self.operationMemberAuthStateClosure?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

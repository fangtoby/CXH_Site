//
//  CouierTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import UIKit

protocol CouierTableViewCellDelegate:NSObjectProtocol{
    func pushDetails(_ entity:ExpressmailEntity)
    func pushQrcode(_ entity:ExpressmailEntity)
}
/// 揽件cell
class CouierTableViewCell: UITableViewCell {
    weak var delegate:CouierTableViewCellDelegate?
    @IBOutlet weak var border1View: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var lblSN: UILabel!
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    var entity:ExpressmailEntity?
    @IBOutlet weak var lblStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTime.textColor=UIColor.color666()
        btnCode.backgroundColor=UIColor.applicationMainColor()
        btnDetails.backgroundColor=UIColor.applicationMainColor()
        border1View.backgroundColor=UIColor.borderColor()
        borderView.backgroundColor=UIColor.viewBackgroundColor()
        lblStatus.textColor=UIColor.applicationMainColor()
        btnCode.layer.cornerRadius=5
        btnCode.addTarget(self, action:#selector(qrcode), for: UIControlEvents.touchUpInside)
        btnDetails.layer.cornerRadius=5
        btnDetails.addTarget(self, action:#selector(details), for: UIControlEvents.touchUpInside)
        self.selectionStyle = .none
        
    }
    @objc func qrcode(){
        delegate?.pushQrcode(entity!)
    }
    @objc func details(){
        delegate?.pushDetails(entity!)
    }
    func updateCell(_ entity:ExpressmailEntity,statu:Int){
        if statu != 2{
            btnCode.isHidden=true
        }
        self.entity=entity
        if entity.expressmailSN != nil{
            lblSN.text="单号:\(entity.expressmailSN!)"
        }
        if entity.ctime != nil{
            lblTime.text="录入时间:\(entity.ctime!)"
        }
        if entity.status == 1{
            lblStatus.text="待录入"
        }else if entity.status == 2{
            lblStatus.text="已录入"
        }else if entity.status == 3{
            lblStatus.text="已过期"
        }else if entity.status == 4{
            lblStatus.text="司机已签收"
        }else if entity.status == 5{
            lblStatus.text="总仓签收"
        }else if entity.status == 6{
            lblStatus.text="已出库"
        }else if entity.status == 7{
            lblStatus.text="修改中"
        }else if entity.status == 8{
            lblStatus.text="已退回"
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

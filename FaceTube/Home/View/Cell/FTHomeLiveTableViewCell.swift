//
//  FTHomeLiveTableViewCell.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/13.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import Kingfisher

class FTHomeLiveTableViewCell: UITableViewCell {

    var backgroundColorView: UIView!
    var userView: FTUserView!
    var nickLabel: UILabel!
    var position: UIImageView!
    var cityLabel: UILabel!
    var onlineIcon: UIImageView!
    var onlineLabel: UILabel!
    var instructLabel: UILabel!
    var thumbImageView: UIImageView!
    var pointLabel: UILabel!
    
    //MARK: ************************  life cycle  ************************
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initialize(){
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.backgroundColor()
        self.contentView.clipsToBounds = true
        
        backgroundColorView = UIView()
        backgroundColorView.backgroundColor = UIColor.white
        contentView.addSubview(backgroundColorView)
        
        userView = FTUserView()
        contentView.addSubview(userView)
        
        nickLabel = UILabel()
        nickLabel.font = UIFont.ft_medium(16)
        nickLabel.textColor = UIColor.mainTextColor()
        contentView.addSubview(nickLabel)
        
        position = UIImageView.init(image: UIImage.init(named: "ft_position_icon"))
        contentView.addSubview(position)
        
        cityLabel = UILabel()
        cityLabel.font = UIFont.ft_regular(13)
        cityLabel.textColor = UIColor.assistTextColor()
        cityLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(cityLabel)
        
        onlineIcon = UIImageView.init(image: UIImage.init(named: "ft_online_icon"))
        contentView.addSubview(onlineIcon)
        
        onlineLabel = UILabel()
        onlineLabel.font = UIFont.ft_regular(13)
        onlineLabel.textColor = UIColor.assistTextColor()
        contentView.addSubview(onlineLabel)
        
        pointLabel = UILabel()
        pointLabel.font = UIFont.ft_regular(13)
        pointLabel.textColor = UIColor.assistTextColor()
        contentView.addSubview(pointLabel)
        
        instructLabel = UILabel()
        instructLabel.font = UIFont.ft_medium(15)
        instructLabel.textColor = UIColor.mainTextColor()
        instructLabel.lineBreakMode = .byTruncatingTail
        instructLabel.numberOfLines = 5
        contentView.addSubview(instructLabel)
        
        thumbImageView = UIImageView()
        thumbImageView.contentMode = .scaleToFill
        contentView.addSubview(thumbImageView)
        
//        //处理模糊
//        let blurEffect: UIBlurEffect = UIBlurEffect.init(style: .light)
//        let visualEffectView: UIVisualEffectView = UIVisualEffectView.init(effect: blurEffect)
//        thumbImageView.addSubview(visualEffectView)
        
        backgroundColorView .snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(contentView)
            make.top.equalTo(contentView).offset(5)
        }
        
        userView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(15)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        nickLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(userView.snp.trailing).offset(10)
            make.top.equalTo(userView.snp.top)
            make.trailing.lessThanOrEqualTo(contentView.snp.trailing).offset(-10)
        }
        
        position.snp.makeConstraints { (make) in
            make.leading.equalTo(nickLabel.snp.leading)
            make.top.equalTo(nickLabel.snp.bottom).offset(5)
            make.size.equalTo(CGSize.init(width: 12, height: 13))
        }
        
        cityLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(position.snp.trailing).offset(7)
            make.top.equalTo(nickLabel.snp.bottom).offset(5)
            make.width.lessThanOrEqualTo(80)
        }
        
        onlineIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(cityLabel.snp.trailing).offset(15)
            make.top.equalTo(cityLabel.snp.top)
            make.height.width.equalTo(14)
        }
        
        onlineLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(onlineIcon.snp.trailing).offset(5)
            make.top.equalTo(cityLabel.snp.top)
        }
        
        pointLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(onlineLabel.snp.trailing).offset(15)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.top.equalTo(cityLabel.snp.top)
        }
        
        instructLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.top.equalTo(userView.snp.bottom).offset(10)
        }
        
        thumbImageView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(contentView)
            make.top.equalTo(instructLabel.snp.bottom).offset(10)
        }
        
        
//        visualEffectView.snp.makeConstraints { (make) in
//            make.edges.equalTo(thumbImageView)
//        }
    }
    
    
    
    
    
    
    
    
    //MARK: interface methods
    
    public func updateHomeLiveCell(model: FTHomeLiveModel){
        
        userView.updateUserViewWithHomeLiveModel(model: model)
        nickLabel.text = model.creator?.nick
        cityLabel.text = model.city
        onlineLabel.text = FTTool.number2String(num: model.online_users)
        
        let points: NSMutableArray = NSMutableArray()
        for lb in (model.extra?.label)!{
            points.add(lb.tab_name as Any)
        }
        if points.count != 0 {
            let pointsStr = points.componentsJoined(by: " · ");
            pointLabel.text = pointsStr
        }
        
        
        //封面图的处理
        thumbImageView.backgroundColor = UIColor.randomColor()
        let url = URL(string: (model.creator?.portrait)!)
        thumbImageView.kf.setImage(with: url);
        
        //name不为空
        if ((model.name != nil) && model.name.characters.count != 0) {
            
            instructLabel.isHidden = false
            instructLabel.text = model.name
            thumbImageView.snp.remakeConstraints({ (make) in
                make.bottom.leading.trailing.equalTo(contentView)
                make.top.equalTo(instructLabel.snp.bottom).offset(10)
            })
            
        }else{
            
            instructLabel.isHidden = true
            thumbImageView.snp.remakeConstraints({ (make) in
                make.bottom.leading.trailing.equalTo(contentView)
                make.top.equalTo(userView.snp.bottom).offset(10)
            })
        }
        
    }
    

}

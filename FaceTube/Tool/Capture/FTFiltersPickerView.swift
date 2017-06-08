//
//  FTFiltersPickerView.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/6/8.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import SnapKit


class FTFiltersPickerView: UIView {

    var picker: UIPickerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(){
        
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = false
        self.addSubview(picker)
        picker.transform = CGAffineTransform.init(rotationAngle: -.pi/2.0)
        
        picker.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(self.snp.width)
            make.width.equalTo(self.snp.height)
        }
    }

}

extension FTFiltersPickerView: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        //隐藏分割线 分割线的高度为0.5
        pickerView.subviews.forEach {
            $0.isHidden = $0.frame.height < 1.0
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FTPhotoFilters.filterDisplayNames().count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        let title: NSString = NSString.init(string: FTPhotoFilters.filterDisplayNames()[0])
        return title.size(attributes: [NSFontAttributeName:UIFont.ft_regular(15)]).width+20
    }
}

extension FTFiltersPickerView: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if  let lb = view as? UILabel {
            label = lb
        }else{
            label = UILabel()
            label.textAlignment = .center
        }
        label.text = FTPhotoFilters.filterDisplayNames()[row]
        label.transform = CGAffineTransform.init(rotationAngle: .pi/2.0)
        return label
    }
}

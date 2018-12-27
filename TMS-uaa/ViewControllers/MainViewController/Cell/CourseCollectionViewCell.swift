//
//  CourseCollectionViewCell.swift
//  TMS-uaa
//
//  Created by JoviCheng on 2018/12/11.
//  Copyright © 2018年 JoviCheng. All rights reserved.
//

import UIKit
import expanding_collection

class CourseCollectionViewCell: BasePageCollectionCell {
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var courseTitle: UILabel!
    @IBOutlet var teacherName: UILabel!
    @IBOutlet var weekText: UILabel!
    @IBOutlet var section: UILabel!
    @IBOutlet var place: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        courseTitle.layer.shadowRadius = 2
        courseTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        courseTitle.layer.shadowOpacity = 0.2
        
        teacherName.layer.shadowRadius = 2
        teacherName.layer.shadowOffset = CGSize(width: 0, height: 3)
        teacherName.layer.shadowOpacity = 0.2
        
        weekText.layer.shadowRadius = 2
        weekText.layer.shadowOffset = CGSize(width: 0, height: 3)
        weekText.layer.shadowOpacity = 0.2
        
        section.layer.shadowRadius = 2
        section.layer.shadowOffset = CGSize(width: 0, height: 3)
        section.layer.shadowOpacity = 0.2
        
        place.layer.shadowRadius = 2
        place.layer.shadowOffset = CGSize(width: 0, height: 3)
        place.layer.shadowOpacity = 0.2
    }
}

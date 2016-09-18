//
//  String+Helpers.swift
//  RxPlaygrounds
//
//  Created by 杨弘宇 on 2016/9/18.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import Foundation

extension String {
    
    var firstLetterUppercased: String {
        let firstLetter = self.substring(to: self.index(after: self.startIndex)).uppercased()
        let rest = self.substring(from: self.index(after: self.startIndex))
        return firstLetter + rest
    }
    
}

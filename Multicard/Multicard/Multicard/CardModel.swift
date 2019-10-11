//
//  CardModel.swift
//  Multicard
//
//  Created by Кирилл Верхоутров on 11/10/2019.
//  Copyright © 2019 Кирилл Верхоутров. All rights reserved.
//

import Foundation

import Foundation
import UIKit

struct CardModelDataSource {
    var title: String
    var subTitle: String?
    
    init(title: String, subTitle: String? = nil) {
        self.title = title
        self.subTitle = subTitle
    }
}

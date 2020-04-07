//
//  Design.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 24.03.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import UIKit

enum Design {
    
    enum Colors {
        static let greenColor = #colorLiteral(red: 0.4941176471, green: 0.737254902, blue: 0.3490196078, alpha: 1)
        static let whiteColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        static let greyColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.231372549, alpha: 1)
        static let blueColor = #colorLiteral(red: 0.2117647059, green: 0.5490196078, blue: 0.7490196078, alpha: 1)
        static let transparentGreyColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.231372549, alpha: 0.6522099743)
        static let blackColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    enum ImageNames {
        static let scanImage = "barcode.viewfinder"
        static let logoutImage = "arrow.uturn.left.square"
        static let barcodeImage = "barcode"
    }
    
    enum Fonts {
        enum BigHeader {
            static let font = UIFont.boldSystemFont(ofSize: 30)
            static let color = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.231372549, alpha: 1)
        }
        enum MiniHeader {
            static let font = UIFont.boldSystemFont(ofSize: 20)
            static let color = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.231372549, alpha: 1)
        }
        enum RegularText {
            static let font = UIFont.systemFont(ofSize: 20)
            static let color = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.231372549, alpha: 1)
        }
    }
}

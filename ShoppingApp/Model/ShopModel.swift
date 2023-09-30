//
//  ShopModel.swift
//  ShoppingApp
//
//  Created by 酒匂竜也 on 2023/09/28.
//

import Foundation
struct ShopModel:Decodable {
        let date: String
        let janl: String
        let price: Int
        let product: String
        let shopImageURL: String? // 画像URLの文字列を格納

        enum CodingKeys: String, CodingKey {
            case date = "DATE"
            case janl = "JANL"
            case price = "PRICE"
            case product = "PRODACT"
            case shopImageURL = "SHOP_IMG"
        }
    }

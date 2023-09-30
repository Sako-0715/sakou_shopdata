//
//  ImageModel.swift
//  ShoppingApp
//
//  Created by 酒匂竜也 on 2023/09/30.
//

import Foundation
import RealmSwift

class ImageModel: Object {
    @Persisted var imageData: Data? //画像データを保存するプロパティ
    
    static func saveImageToRealm(_ imageData: Data) {
            do {
                let realm = try Realm()
                let imageModel = ImageModel()
                imageModel.imageData = imageData
                
                try realm.write {
                    realm.add(imageModel)
                }
            } catch {
                print("Realmへの保存エラー: \(error.localizedDescription)")
            }
        }
}

//
//  HistoryViewController.swift
//  ShoppingApp
//
//  Created by 酒匂竜也 on 2023/09/26.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data:[ShopModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        print("sakouaaaa")
        //APIから投稿履歴を取得
                Api()
        
            }
            
    func Api() {
        guard let url = URL(string: "http://localhost:8888/ShoppingHistory.php") else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("エラーです")
                return
            }
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                            print("API応答: \(responseString)")
                        }
                self.data = self.parseData(data: data)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }.resume()
    }
    
    func parseData(data: Data) -> [ShopModel] {
            // データを適切にパースして、データモデルの配列に格納するロジックを実装
        var parsedData: [ShopModel] = []
        
        do {
            let decoder = JSONDecoder()
            parsedData = try decoder.decode([ShopModel].self, from: data)
        } catch {
            print("データーのパースエラー: \(error.localizedDescription)")
        }

            return parsedData
        }

            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return data.count
            }
            func numberOfSections(in tableView: UITableView) -> Int {
                return 1
            }
    
    // Realmから画像データを取得し、UIImageViewに表示するメソッド
        func loadImageFromRealm(imageView: UIImageView, indexPath: IndexPath) {
            do {
                let realm = try Realm()
                let shopData = data[indexPath.row]

                // Realmから該当の画像データを取得
                if let imageModel = realm.object(ofType: ImageModel.self, forPrimaryKey: shopData.id) {
                    // 取得した画像データをUIImageViewに設定
                    if let imageData = imageModel.imageData {
                        imageView.image = UIImage(data: imageData)
                    }
                } else {
                    // 該当の画像データが見つからなかった場合の処理
                    imageView.image = UIImage(named: "placeholder_image") // 代替のデフォルト画像を設定
                }
            } catch {
                print("Realmからの画像データ取得エラー: \(error.localizedDescription)")
            }
        }

            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                let imageView = cell.contentView.viewWithTag(1) as? UIImageView
                let janlLabel = cell.contentView.viewWithTag(2) as! UILabel
                let prodact = cell.contentView.viewWithTag(3) as! UILabel
                let price = cell.contentView.viewWithTag(4) as! UILabel
                let date = cell.contentView.viewWithTag(5) as! UILabel
                let shopData = data[indexPath.row]
                
                // 画像を読み込む
                loadImageFromRealm(imageView: imageView, indexPath: indexPath)
                
                janlLabel.text = shopData.janl
                prodact.text = shopData.product
                price.text = "\(shopData.price)"
                date.text = shopData.date
                
                
                //        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
                //        let label = cell.contentView.viewWithTag(2) as! UILabel
                
                cell.selectionStyle = .none
                return cell
            }
                
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 400
    }
            
            /*
             // MARK: - Navigation
             
             // In a storyboard-based application, you will often want to do a little preparation before navigation
             override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             // Get the new view controller using segue.destination.
             // Pass the selected object to the new view controller.
             }
             */
            
        }

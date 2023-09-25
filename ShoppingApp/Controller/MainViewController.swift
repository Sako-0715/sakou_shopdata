//
//  MainViewController.swift
//  ShoppingApp
//
//  Created by 酒匂竜也 on 2023/09/26.
//

import UIKit
import Photos
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var ImageCamera: UIImageView!
    @IBOutlet weak var JanlText: UITextField!
    @IBOutlet weak var PriceText: UITextField!
    @IBOutlet weak var ProdactText: UITextField!
    @IBOutlet weak var InputButton: UIButton!
    
    var privateCamera = false
    var JanlPicker = UIPickerView()
    var PricePicker = UIPickerView()
    var ProdactNameString = ""
    
    //ジャンル
    var JanlString = [String]()
    //個数
    var PriceInt = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JanlText.inputView = JanlPicker
        JanlPicker.delegate = self
        JanlPicker.dataSource = self
        
        JanlText.delegate = self
        
        JanlPicker.tag = 1
        
        PriceText.inputView = PricePicker
        PricePicker.delegate = self
        PricePicker.dataSource = self
        PriceText.delegate = self
        PricePicker.tag = 2
        
        ProdactText.delegate = self
        
        InputButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            JanlString = Util.Janl()
            return JanlString.count
        case 2:
            PriceInt = ([Int])(1...10)
            return PriceInt.count
        default:
            return 0
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            JanlText.text = JanlString[row]
            JanlText.resignFirstResponder()
            break
        case 2:
            PriceText.text = String(PriceInt[row])
            PriceText.resignFirstResponder()
            break
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return JanlString[row]
        case 2:
            return String(PriceInt[row])
        default:
            return ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if JanlText.text?.count ?? 0  > 0 && PriceText.text?.count ?? 0 > 0 && ProdactText.text?.count ?? 0 > 0 {
            
            InputButton.isEnabled = true
            
        } else {
            
            InputButton.isEnabled = false
        }
        
        
    }
    
    
    @IBAction func SendButton(_ sender: Any) {
        
        //データーベースに送信する
        let url = "http://localhost:8888/shoping.php"
        let date = Date() // May 4, 2020, 11:16 AM
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate = formatter.string(from: date) // 2020-05-04 11:16:31
        ImageCamera.image!.jpegData(compressionQuality: 1)
        let shopdata:[String: Any] = ["Janl":JanlText.text!,"Price":PriceText.text!,"Prodact": ProdactText.text!,"Shop_Image": ImageCamera.image,"date":strDate]
        
        AF.request(url,method:.post,parameters: shopdata,encoding:URLEncoding.default).responseData { response in
            switch response.result {
            case.success(let data):
                //print(String(data: data, encoding: .utf8)!)
                self.ProdactText.text = String(data: data, encoding: .utf8)!
            case.failure(let error):print("Error: \(error)")
            }
        }
        
        
        ImageCamera.image =  UIImage(named: "bkcamera")
        JanlText.text = ""
        PriceText.text = ""
        ProdactText.text = ""
        
        
    }
    
    
        
    @IBAction func tapGesture(_ sender: Any) {
        openCamera()
    }
    
    
    func openCamera(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            privateCamera = true
            //            cameraPicker.showsCameraControls = true
            present(cameraPicker, animated: true, completion: nil)
            
        }else{
            
        }
    }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            if let pickedImage = info[.editedImage] as? UIImage
            {
                ImageCamera.image = pickedImage
                //閉じる処理
                picker.dismiss(animated: true, completion: nil)
            }
            
        }
        
        // 撮影がキャンセルされた時に呼ばれる
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
            
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    }

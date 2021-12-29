//
//  AddViewController.swift
//  WordList
//
//  Created by Owner on 2021/12/27.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet var englishTextField:UITextField!
    @IBOutlet var japaneseTextField:UITextField!
    
    var wordArray:[Dictionary<String,String>] = []
    
    let saveData = UserDefaults.standard
    
    var editNum:Int! = -1
    
    var status:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if saveData.array(forKey: "WORD") != nil{
            wordArray = saveData.array(forKey: "WORD") as! [Dictionary<String,String>]
        }
        
        if editNum != -1 {
            englishTextField.text = wordArray[editNum]["english"]
            japaneseTextField.text = wordArray[editNum]["japanese"]
        }
        
        
        
    }
    
    @IBAction func saveWord(){
        let wordDctionary =
        ["english":englishTextField.text! , "japanese":japaneseTextField.text!]
        
        
        //        空白対策
        if englishTextField.text == "" || japaneseTextField.text == ""{
            
            let alert = UIAlertController(
                title:"入力されていません",
                message: "入力されていない場所があります",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title:"OK",
                style: .default,
                handler:nil
            ))
            present(alert,animated:true,completion: nil)
            
            return
        }
        
        //        Word２Vec対策
        answerOutput()
        print (status)
        if !status {
            
            let alert = UIAlertController(
                title:"Word2Vecに対応してません",
                message: "対応していない単語です、別の単語に変更してください。",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title:"OK",
                style: .default,
                handler:nil
            ))
            present(alert,animated:true,completion: nil)
            
            return
        }
        
        if editNum != -1{
            wordArray.remove(at: editNum)
            wordArray.insert(wordDctionary, at: editNum)
            
        }else{
            wordArray.append(wordDctionary)
        }
        
        
        saveData.set(wordArray ,forKey: "WORD")
        
        let alert = UIAlertController(
            title:"保存完了",
            message: "単語の登録が完了しました",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title:"OK",
            style: .default,
            handler:nil
        ))
        present(alert,animated:true,completion: nil)
        
        englishTextField.text = ""
        japaneseTextField.text = ""
        
        if editNum != -1 {
            editNum = -1
            
            //            TODO:編集時は前の画面にもどるようにする
        }
    }
    
    //キーボードを消すやつ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func answerOutput(){
        
        let str:String = japaneseTextField.text!
        
        print(str.urlEncoded)
        
        struct RecebedMain: Codable{
            let status:String
            let mode:String
            let data:[String]
        }
        
        let jsonUrlString = String("http://127.0.0.1:5000/near?str=\(str.urlEncoded)&get_number=50")
        
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            do{
                let json = String(data: data, encoding: .utf8)!
                print(json)
                
                let myblog = try JSONDecoder().decode(RecebedMain.self, from: data)
                print(myblog.status)
                print(myblog.mode)
                print(myblog.data)
                
                self.status = myblog.status == "OK"
                
                
            } catch let jsonError{
                print("error", jsonError)
            }
        }.resume()
        
        
        
    }
}


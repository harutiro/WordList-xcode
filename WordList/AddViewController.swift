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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if saveData.array(forKey: "WORD") != nil{
            wordArray = saveData.array(forKey: "WORD") as! [Dictionary<String,String>]
        }
    }
    
    @IBAction func saveWord(){
        let wordDctionary =
        ["english":englishTextField.text! , "japanese":japaneseTextField.text!]
        
        wordArray.append(wordDctionary)
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
    }
    

}

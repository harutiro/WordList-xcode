//
//  ViewController.swift
//  WordList
//
//  Created by Owner on 2021/12/27.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func back(sender:UIStoryboardSegue){
        
    }
    
    @IBAction func startButtonTapped(){
        let saveData = UserDefaults.standard
        if saveData.array(forKey: "WORD") != nil{
            if saveData.array(forKey: "WORD")!.count > 0{
//                問題VIEWに移動
                performSegue(withIdentifier: "toQuestionView", sender: nil)
            }
        }else{
//            ない場合、アラート表示
            let alert = UIAlertController(
                title: "単語",
                message: "まずは「単語一覧」をタップして単語登録してください",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
                
            ))
            
            self.present(alert,animated:true,completion:nil)
        }
    }

}


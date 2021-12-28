//
//  QuestionViewController.swift
//  WordList
//
//  Created by Owner on 2021/12/27.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionButton1: UIButton!
    @IBOutlet var questionButton2: UIButton!
    @IBOutlet var questionButton3: UIButton!
    @IBOutlet var questionButton4: UIButton!
    @IBOutlet var Image:UIImageView!
    @IBOutlet var nextButton:UIButton!
    
    var isAnswered: Bool = false
    var wordArray:[Dictionary<String,String>] = []
    var nowNumber:Int = 0
    let saveData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        wordArray = saveData.array(forKey:"WORD") as! [Dictionary<String,String>]
        
        wordArray.shuffle()
        questionLabel.text = wordArray[nowNumber]["english"]
    }
    
    @IBAction func nextButtonTapped(){
        if isAnswered{
//            次の問題へ
            nowNumber += 1
            answerLabel.text = ""
            
            if nowNumber < wordArray.count{
//                次の問題を表示
                questionLabel.text = wordArray[nowNumber]["english"]
                isAnswered = false
                nextButton.setTitle("答えを表示", for: .normal)
            }else{
                nowNumber = 0
                performSegue(withIdentifier: "toFinishView", sender: nil)
            }
        }else{
//            答えを表示
            answerLabel.text = wordArray[nowNumber]["japanese"]
            isAnswered = true
            nextButton.setTitle("次へ", for: .normal)
        }
    }
    
    @IBAction func nextQuestionButton(){
        
    }
    
    

}

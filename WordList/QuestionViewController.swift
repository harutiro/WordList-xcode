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
        Image.isHidden = true
        nextButton.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        wordArray = saveData.array(forKey:"WORD") as! [Dictionary<String,String>]
        
        
        wordArray.shuffle()
        questionLabel.text = wordArray[nowNumber]["english"]
        answerOutput()
        
        
        
    }
    
    @IBAction func nextButtonTapped(){
        if isAnswered{
            //            次の問題へ
            nowNumber += 1
            answerOutput()
            
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
            
            
        }
    }
    
    @IBAction func nextQuestionButton(){
        //            答えを表示
        isAnswered = true
        nextButton.setTitle("次へ", for: .normal)
        
        
    }
    
    func answerOutput(){
        
        var answerArray:Array<String> = []
        let str:String = wordArray[nowNumber]["japanese"]!
        
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
                
                answerArray = myblog.data
                answerArray.shuffle()
                
                print(answerArray)
                
                answerArray.insert(str, at: Int.random(in: 0..<4))
                print("😩")
                print(answerArray)
                
                DispatchQueue.main.async {
                    self.questionButton1.setTitle(answerArray[0], for: .normal)
                    self.questionButton2.setTitle(answerArray[1], for: .normal)
                    self.questionButton3.setTitle(answerArray[2], for: .normal)
                    self.questionButton4.setTitle(answerArray[3], for: .normal)
                }
                
                
            } catch let jsonError{
                print("error", jsonError)
            }
        }.resume()
        
        
        
        

    }
    
    
    
}

extension String {
    
    var urlEncoded: String {
        // 半角英数字 + "/?-._~" のキャラクタセットを定義
        let charset = CharacterSet.alphanumerics.union(.init(charactersIn: "/?-._~"))
        // 一度すべてのパーセントエンコードを除去(URLデコード)
        let removed = removingPercentEncoding ?? self
        // あらためてパーセントエンコードして返す
        return removed.addingPercentEncoding(withAllowedCharacters: charset) ?? removed
    }
}

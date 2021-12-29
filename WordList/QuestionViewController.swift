//
//  QuestionViewController.swift
//  WordList
//
//  Created by Owner on 2021/12/27.
//

import UIKit
import AVFoundation

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
    var ansNumber:Int = 0
    var rightNumber:Int = 0
    
    let trueSoundPlayer = try! AVAudioPlayer(data:NSDataAsset(name:"trueSound")!.data,fileTypeHint: "mp3")
    
    let falseSoundPlayer = try! AVAudioPlayer(data:NSDataAsset(name:"falseSound")!.data,fileTypeHint: "mp3")
    
    
    // ①セグエ実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // ②Segueの識別子確認
        if segue.identifier == "toFinishView" {
            // ③遷移先ViewCntrollerの取得
            let nextView = segue.destination as! FinishViewController
            // ④値の設定
            nextView.rightNumber = rightNumber
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Image.isHidden = true
        nextButton.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        wordArray = saveData.array(forKey:"WORD") as! [Dictionary<String,String>]
        
        
        wordArray.shuffle()
        questionLabel.text = wordArray[nowNumber]["english"]
        answerOutput()
        
        
        
    }
    
    @IBAction func questionActionButton1(){
        ansCheck(num: 0)
    }
    
    @IBAction func questionActionButton2(){
        ansCheck(num: 1)
    }
    
    @IBAction func questionActionButton3(){
        ansCheck(num: 2)
    }
    
    @IBAction func questionActionButton4(){
        ansCheck(num: 3)
    }
    
    @IBAction func nextQuestionButton(){
        
        Image.isHidden = true
        nextButton.isHidden = true
        
        nowNumber += 1
        
        if nowNumber < wordArray.count{
            //                次の問題を表示
            questionLabel.text = wordArray[nowNumber]["english"]
            answerOutput()
        }else{
            nowNumber = 0
            performSegue(withIdentifier: "toFinishView", sender: nil)
        }
        
    }
    
    func ansCheck(num:Int){
        
        
        
        
        if num == ansNumber{
            Image.isHidden = false
            nextButton.isHidden = false
            Image.image = UIImage(named: "true")
            
            rightNumber += 1
            
            trueSoundPlayer.currentTime = 0
            trueSoundPlayer.play()
            
            print(rightNumber)
            
        }else{
            Image.isHidden = false
            nextButton.isHidden = false
            Image.image = UIImage(named: "false")
            
            falseSoundPlayer.currentTime = 0
            falseSoundPlayer.play()
        }
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
                
                self.ansNumber = Int.random(in: 0..<4)
                
                answerArray.insert(str, at: self.ansNumber)
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

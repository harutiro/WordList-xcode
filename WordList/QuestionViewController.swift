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
        
        questionButton1.layer.cornerRadius = 6
        questionButton1.layer.masksToBounds = true
        questionButton2.layer.cornerRadius = 6
        questionButton2.layer.masksToBounds = true
        questionButton3.layer.cornerRadius = 6
        questionButton3.layer.masksToBounds = true
        questionButton4.layer.cornerRadius = 6
        questionButton4.layer.masksToBounds = true
        
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
        
        let rgba = UIColor(red: 48/255, green: 176/255, blue: 199/255, alpha: 1.0) // ボタン背景色設定
        
        if ansNumber == 0{
            questionButton1.backgroundColor = rgba
        }else if ansNumber == 1{
            questionButton2.backgroundColor = rgba
        }else if ansNumber == 2{
            questionButton3.backgroundColor = rgba
        }else if ansNumber == 3{
            questionButton4.backgroundColor = rgba
        }
        questionButton1.isEnabled = true
        questionButton2.isEnabled = true
        questionButton3.isEnabled = true
        questionButton4.isEnabled = true
        
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
        
        
        var rgba:UIColor!
        
        if num == ansNumber{
            Image.isHidden = false
            nextButton.isHidden = false
            Image.image = UIImage(named: "true")
            
            rightNumber += 1
            
            trueSoundPlayer.currentTime = 0
            trueSoundPlayer.play()
            
            print(rightNumber)
            
            rgba = UIColor(red: 64/255, green: 205/255, blue: 42/255, alpha: 1.0) //
            
        }else{
            Image.isHidden = false
            nextButton.isHidden = false
            Image.image = UIImage(named: "false")
            
            falseSoundPlayer.currentTime = 0
            falseSoundPlayer.play()
            
            rgba = UIColor(red: 252/255, green: 53/255, blue: 10/255, alpha: 1.0) //
        }
        
//         ボタン背景色設定
        
        if ansNumber == 0{
            questionButton1.backgroundColor = rgba
        }else if ansNumber == 1{
            questionButton2.backgroundColor = rgba
        }else if ansNumber == 2{
            questionButton3.backgroundColor = rgba
        }else if ansNumber == 3{
            questionButton4.backgroundColor = rgba
        }
        
        questionButton1.isEnabled = false
        questionButton2.isEnabled = false
        questionButton3.isEnabled = false
        questionButton4.isEnabled = false
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
        
        let jsonUrlString = String("https://0110-152-70-80-176.jp.ngrok.io/near?str=\(str.urlEncoded)&get_number=50")
        
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

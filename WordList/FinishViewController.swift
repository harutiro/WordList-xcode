//
//  FinishViewController.swift
//  WordList
//
//  Created by Owner on 2021/12/27.
//

import UIKit

class FinishViewController: UIViewController {
    
    var rightNumber = 0
    
    @IBOutlet var outputLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        outputLabel.text = String(rightNumber) + "問せいかい"
        
        

        // Do any additional setup after loading the view.
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

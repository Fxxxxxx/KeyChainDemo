//
//  ViewController.swift
//  KeyChainDemo
//
//  Created by Fxxx on 2017/12/8.
//  Copyright © 2017年 Aaron Feng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var lb: UILabel!
    
    let tool = KeyChainTool.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEdit))
        self.view.addGestureRecognizer(tap)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func endEdit() {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            //save
            if tool.addToKeyChain(data: tf.text!, key: "content") {
                print("保存成功")
            }else {
                print("保存失败")
            }
            
        case 1:
            //read
            if let str = tool.getDataForKey(key: "content") as? String {
                lb.text = str
            }else {
                print("读取失败")
            }
            
        case 2:
            //update
            if tool.updateData(data: tf.text!, key: "content") {
                print("更新成功")
            }else {
                print("更新失败")
            }
            
        case 3:
            //delete
            if tool.removeDataForKey(key: "content") {
                print("删除成功")
            }else {
                print("删除失败")
            }
            
        default:
            break
        }
        
        
    }
    
    

}


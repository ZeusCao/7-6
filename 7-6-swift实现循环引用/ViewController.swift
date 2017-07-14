//
//  ViewController.swift
//  7-6-swift实现循环引用
//
//  Created by Zeus on 2017/7/6.
//  Copyright © 2017年 Zeus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 定义属性
    var completionCallBack : (() -> ())?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // block中如果使用了block要特别小心
        // 这里只是闭包对self进行了copy,闭包执行完成之后，会自动销毁，同时释放对self的引用（单方向是不需要担心循环引用的）
        // --- 如果要造成循环引用，需要self对闭包进行引用
        
//        loadData { 
//            print(self.view)
//        }
        
        
        // 解除循环引用需要打断链条
        // 方法1：oc方法
           // 细节1：var进行修饰 （weak可能会被在运行时进行修改，指向的对象一旦被释放就会指向nil，所以不能用let修饰）
           // 细节2：？
              // 解包有两种方式 ？：可选解包：如果，self已经被释放，不会向对象发送getter的消息，更加安全合理
              //              ！：强行解包 : 如果self已经被释放，强行解包会导致崩溃
        
        
//        weak var weakSelf = self
//        loadData {
//            
//            // weakSelf?.view --- 只是单纯的发送消息，没有计算
//            // 强行解包，因为需要计算，可选项不能直接参与到计算
//            print(weakSelf?.view)
//        }
        
        // *****************************方法二 ：swift推荐方法
        // [weak self]标识{}中的多有的self都是弱引用，需要注意解包
        loadData { [weak self] in
            
            print(self?.view)
            
        }
        
        
        
        
    }

    
    func loadData(completion: @escaping () -> ()) -> (){
        
        // 使用属性记录闭包，就意味着self对闭包进行了引用（此时self释放不了）
        completionCallBack = completion
        
        // 异步
        DispatchQueue.global().async{
            print("耗时操作")
            
            Thread.sleep(forTimeInterval: 2);
            
            DispatchQueue.main.async{
                
                // 回调，执行闭包
                completion()
            }
            
        }
        
    }
   
    // 类似于oc的dealloc
    deinit {
        
    }
    

}


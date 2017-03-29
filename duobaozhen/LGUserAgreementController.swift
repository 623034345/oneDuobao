//
//  LGUserAgreementController.swift
//  duobaozhen
//
//  Created by Macintosh HD on 2017/1/20.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

import UIKit

class LGUserAgreementController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "注册协议"
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        let image = UIImage(named: "user_agreement");
        let imageV = UIImageView(image: image)
        imageV.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: (image?.size.height)! * SCREEN_SCALE_HEIGHT + 100)
        scrollView.addSubview(imageV)
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: imageV.bounds.size.height + 20)
        
        scrollView.backgroundColor = UIColor.white
        scrollView.bounces = false
        self.view.addSubview(scrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.view.bounds)
        return scroll
    }()
    
}

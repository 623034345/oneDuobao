//
//  LGNetworkManager.swift
//  duobaozhen
//
//  Created by Macintosh HD on 2017/1/21.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class LGNetworkManager: NSObject {
    
    /// 网络工具单例类
    static let shared = LGNetworkManager()
    
}

extension LGNetworkManager {
    
    func getRequest(url: String, parameters:[String: AnyObject], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        DispatchQueue.global().async {
            //        使用Alamofire进行网络请求时，调用该方法的参数都是通过getRequest(urlString， params, success :, failture :）传入的，而success传入的其实是一个接受           [String : AnyObject]类型 返回void类型的函数
            
            Alamofire.request(url, method: .get, parameters: parameters)
                .responseJSON { (response) in
                    //当请求后response是我们自定义的，这个变量用于接受服务器响应的信息
                    //使用switch判断请求是否成功，也就是response的result
                    switch response.result {
                    //当响应成功是，使用临时变量value接受服务器返回的信息并判断是否为[String: AnyObject]类型 如果是那么将其传给其定义方法中的success
                    case .success(let value):
                        DispatchQueue.main.async {
                            success(value as! [String: AnyObject])
//                            let json = JSON(value)
                        }
                        break
                    case .failure(let error):
                        DispatchQueue.main.async {
                            failture(error)
                        }
                        break
                    }
            }
        }
    }
    
    func postRequest(url : String, parametes : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        
        DispatchQueue.global().async {
            
            Alamofire.request(url, method: .post, parameters: parametes).responseJSON { (response) in
                
                switch response.result {
                case .success(let value):
                    DispatchQueue.main.async {
                        let json = JSON(value)
                        success(json.dictionaryObject as! [String : AnyObject])
                    }
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        
                        failture(error)
                        print(error)
                    }
                    break
                }
            }
        }
    }
}

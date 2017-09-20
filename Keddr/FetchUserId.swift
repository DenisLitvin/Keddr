//
//  FetchUserId.swift
//  Keddr
//
//  Created by macbook on 19.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import Kanna

extension Api {
    static func fetchUserId(complition: @escaping (String?) -> ()){
        URLSession.shared.dataTask(with: URL(string: "https://keddr.com/profile/")!) { (data, response, error) in
            if error != nil{
                complition(nil)
            } else if let data = data,
                let html = HTML(html: data, encoding: .utf8),
                let idNode = html.at_css("#SaveUpload > input[type=\"hidden\"]:nth-child(10)"),
                let uid = idNode["value"]{
                complition(uid)
            } else { complition(nil) }
        }.resume()
    }
}








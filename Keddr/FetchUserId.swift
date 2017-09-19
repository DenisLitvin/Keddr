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
            var uid: String?
            let data = HTML(html: data!, encoding: .utf8)
            if let idNode = data?.at_css("#SaveUpload > input[type=\"hidden\"]:nth-child(10)"), let id = idNode["value"]{
                uid = id
            }
            complition(uid)
        }.resume()
    }
}








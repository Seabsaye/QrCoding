//
//  Http.swift
//  TestAppQRAPI
//
//  Created by Sebastian Kolosa on 2016-09-24.
//  Copyright © 2016 SebastianKolosa. All rights reserved.
//

import Foundation

class Http : NSObject {
    typealias CompletionHandler = (_ dataDict: NSDictionary) -> Void
    static func getRequest(strUrl: String, completionHandler: @escaping CompletionHandler) {
        let url = URL(string: strUrl)
        let task = URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if (error != nil) {
                print(error)
                return
            }
            if let data = data {
                var jsonData: NSDictionary!
                do {
                    jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    completionHandler(jsonData)
                } catch {
                    print(error)
                    return
                }
            }
        }
        task.resume()
    }
}

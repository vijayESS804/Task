//
//  ServiceConnector.swift
//  Venkat Reddy
//
//  Created by ojas on 18/12/19.
//  Copyright © 2019 ojas. All rights reserved.
//

import UIKit

protocol ServiceConnectorDelegate {
    
    func didReceiveResponse(data : AnyObject)
    func didFailResponse()
    
}
class ServiceConnector: NSObject {

    var delegate:ServiceConnectorDelegate?
    
    func initiateServiceCall(delegate : Any, httpMethod: String , pageNo : String)
    {
        self.delegate = (delegate as! ServiceConnectorDelegate)
        
        let UrlString = String(format: SERVICE_URL + "page=\(pageNo)")
        guard let serviceUrl = URL(string: UrlString)
            else {
                return
        }
        
        var serviceRequest = URLRequest(url: serviceUrl)
        serviceRequest.httpMethod = httpMethod
        serviceRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        session.dataTask(with: serviceRequest) { (data, response, error) in
            
            guard let dataObj = data
                else{  return }
            
            if error == nil
            {
                do {
                       let json = try JSONSerialization.jsonObject(with: dataObj, options: [])
                    self.delegate?.didReceiveResponse(data: json as AnyObject)
                       print(json)
                   } catch {
                    self.delegate?.didFailResponse()
                       print(error)
                   }
            }
            else
            {
                self.delegate?.didFailResponse()
            }
            
        }.resume()
    }
}

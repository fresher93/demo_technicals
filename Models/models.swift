//
//  models.swift
//  Calculator
//
//  Created by Bui Cong Dai on 6/16/20.
//  Copyright © 2020 HoangHai. All rights reserved.
//
//  HTTPClient.swift
//  Test_Bcdai_Os
//
//  Created by Bui Cong Dai on 6/16/20.
//  Copyright © 2020 Bui Cong Dai. All rights reserved.
//

import Foundation
enum APIError: Error{
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case jsonParsingFailure
    case responseUnsuccessful
    
    var localizedDescription: String{
        switch self {
        case .requestFailed:
            return "request failed"
        
        case .jsonParsingFailure:
            return "Json parsing falled"
            
        case .invalidData:
            return "invalid data"
            
        case .jsonConversionFailure:
            return "json conversion fulure"
            
        case .responseUnsuccessful:
            return "response unsuccessful"
        }
    }
}

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}

protocol BaseRequest {
    var base: String { get }
    var path: String { get }
}

extension BaseRequest {
    var apiKey: String {
        return "api_key=34a92f7d77a168fdcd9a46ee1863edf1"
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.query = apiKey
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}
protocol APIClient {
    var sesion: URLSession{get }
    func fetch<T:Decodable>(with request: URLRequest, decode: @escaping (Decodable)-> T?, completion :@escaping (Result<T, APIError>)->Void)
    func fetchPost(url:String, method:String, urlData: String , completion: @escaping([String:String]?)-> Void)
    
}
extension APIClient {
    typealias JSONTaskComletionHandler  = (Decodable?, APIError?)->Void
    
    private func decodingTask<T: Decodable>(with request: URLRequest,decodingType: T.Type, comletionHandler completion: @escaping JSONTaskComletionHandler)->URLSessionTask{
        let task = sesion.dataTask(with: request){
            data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode  == 200{
                if let data = data{
                    do{
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        completion(genericModel,nil)
                    }
                    catch{
                        completion(nil, .jsonConversionFailure)
                    }
                }
                else{
                    completion(nil, .invalidData)
                }
            }
            else{
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }

     func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
    
     func fetchPost(url:String, method:String, urlData: String , completion: @escaping([String:String]?)-> Void)  {
        let urlFind = URL(string:url)
        var request = URLRequest(url:urlFind!)
        request.httpMethod = method
        request.httpBody = urlData.data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {return}
            print(url)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:String]
                print(json)
                completion(json)
            } catch _ as NSError{
                completion(nil)
            }
        }).resume()
    }
}




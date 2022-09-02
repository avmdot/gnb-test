//
//  GNBRequest.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 1/9/22.
//

import Foundation

class GNBRequest {
    
    let url: URL
    
    init?(url: String) {
        guard let url = URL(string: url) else { return nil }
        self.url = url
    }

    func descargarRespuesta( completion: @escaping ([Decodable]?) -> Void) {
        
        var request = URLRequest(url: url, timeoutInterval: 5)
        
        let cachedResponse = URLCache.shared.cachedResponse(for: request)
        
        if(cachedResponse != nil) {
            if let httpResponse = cachedResponse?.response as? HTTPURLResponse, let expiracion = httpResponse.allHeaderFields["Expires"] as? String {
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
                
                if let date = dateFormatter.date(from: expiracion) {
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                    if let dateExpiracion = calendar.date(from:components) {
                        if dateExpiracion.timeIntervalSinceNow < 1 {
                            if let last_modified = httpResponse.allHeaderFields["Last-Modified"] as? String{
                                request.addValue(last_modified, forHTTPHeaderField: "If-Modified-Since")
                                let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                                    if let response = response, let data = data {
                                        if let httpResponse = response as? HTTPURLResponse {
                                            if httpResponse.statusCode == 200 {
                                                let cachedURLResponse = CachedURLResponse(response: response, data: data, userInfo: nil, storagePolicy: .allowedInMemoryOnly)
                                                URLCache.shared.storeCachedResponse(cachedURLResponse, for: request)
                                                self.peticion(request: request) { success in
                                                    completion(success)
                                                    return
                                                }
                                            } else {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    }
                                    if error != nil {
                                        completion(nil)
                                        return
                                    }
                                }
                                task.priority = URLSessionTask.highPriority
                                task.resume()
                            }
                            peticion(request: request) { success in
                                completion(success)
                                return
                            }
                        } else {
                            if let data = cachedResponse?.data {
                                self.parseoJson(data) { respuesta in
                                    completion (respuesta)
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        peticion(request: request) { respuesta in
            completion(respuesta)
        }
    }
    
    private func peticion (request: URLRequest, completion: @escaping ([Decodable]?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data, httpResponse.statusCode == 200 else {
                completion (nil)
                return
            }
            
            self.parseoJson(data) { respuesta in
                completion (respuesta)

            }
            
        }
        task.resume()
    }
    
    private func parseoJson(_ data: Data, completion: @escaping ([Decodable]?) -> Void) {
        var peticionDecodable : [Decodable]?
        if url.absoluteString == GNBConstants.RATE_URL {
            peticionDecodable = try? JSONDecoder().decode([GNBRate].self, from: data)
        } else {
            peticionDecodable = try? JSONDecoder().decode([GNBTransaction].self, from: data)
        }
        completion (peticionDecodable)
        return
    }
}


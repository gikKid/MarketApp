import Foundation
import UIKit

enum NetworkError:Error {
    case noData
}

class NetworkManager {
    
    func load<T>(url:URL, withCompletion completion: @escaping (T?,Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data,_,error) -> Void in
            if let error = error {
                DispatchQueue.main.async {completion(nil,error)}
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {completion(nil, NetworkError.noData)}
                return
            }
            
            switch T.self {
            case is UIImage.Type:
                DispatchQueue.main.async {completion(UIImage(data: data) as? T, nil)}
            case is LatestWrapper.Type:
                let wrapper = try? JSONDecoder().decode(LatestWrapper.self, from: data)
                DispatchQueue.main.async {completion(wrapper as? T, nil)}
            case is FlashSaleWrapper.Type:
                let wrapper = try? JSONDecoder().decode(FlashSaleWrapper.self, from: data)
                DispatchQueue.main.async {completion(wrapper as? T,nil)}
            case is DetailGoods.Type:
                let wrapper = try? JSONDecoder().decode(DetailGoods.self, from: data)
                DispatchQueue.main.async {completion(wrapper as? T,nil)}
            case is WordsWrapper.Type:
                let wrapper = try? JSONDecoder().decode(WordsWrapper.self, from: data)
                DispatchQueue.main.async {completion(wrapper as? T,nil)}
            default: break
            }
        })
        task.resume()
    }
}

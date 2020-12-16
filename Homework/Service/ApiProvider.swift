//
//  ApiProvider.swift
//  Homework
//
//  Created by SangDo on 2020/09/06.
//  Copyright © 2020 SangDo. All rights reserved.
//

import Alamofire
import RxSwift

class ApiProvider {
    static func fetchSearchRx(_ type: String, _ text: String, _ page: Int) -> Observable<Search> {
        return Observable.create { emitter in
            fetchSearch(type: type, text: text, page: page) { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    static func fetchSearch(type: String, text: String, page: Int, onComplete: @escaping (Result<Search, Error>) -> Void) {
        let key = "dd527f9d8d19391e75a8e8e5c6512169"
        let escapedString = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url = "https://dapi.kakao.com/v2/search/\(type)?query=\(escapedString)&size=25&page=\(page)"

        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(key)"
        ]
        AF.request(url, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case.success(let results):
                do {
                    let dataJSON = try JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                    let data = try JSONDecoder().decode(Search.self, from: dataJSON)
                    onComplete(.success(data))
                } catch {
                    onComplete(.failure(error))
                }
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
    }
}

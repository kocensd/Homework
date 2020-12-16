//
//  ServiceProvider.swift
//  Homework
//
//  Created by SangDo on 2020/09/06.
//  Copyright © 2020 SangDo. All rights reserved.
//

import RxSwift
import Foundation

enum Event {
    case click(String)
}

protocol ServiceProtocol {
    var event: PublishSubject<Event> { get }
    
    func save(title: String) -> Observable<Void>
    func fetch() -> Observable<[Word]>
    func search(_ type: String, _ text: String, _ page: Int) -> Observable<Search>
    func moveUrl(_ urlStr: String) -> Observable<Void>
}

class Service: ServiceProtocol {
    var event = PublishSubject<Event>()
    
    func search(_ type: String, _ text: String, _ page: Int) -> Observable<Search> {
        if text == "" {
            return .empty()
        } else {
            return ApiProvider.fetchSearchRx(type, text, page)
        }
    }
    
    func fetch() -> Observable<[Word]> {
        return .just(DbProvider.shared.load())
    }
    
    func save(title: String) -> Observable<Void> {
        if DbProvider.shared.realm.objects(Word.self).filter("searchWord='\(title)'").count == 0 && title != "" {
            let word = Word()
            word.searchWord = title
            DbProvider.shared.save(word)
            return .just(Void())
        } else {
            return .empty()
        }
    }
    
    func moveUrl(_ urlStr: String) -> Observable<Void> {
        if urlStr != "" {
            event.onNext(.click(urlStr))
        }
        return .just(Void())
    }

}

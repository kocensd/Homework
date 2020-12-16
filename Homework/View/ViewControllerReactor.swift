//
//  ViewControllerReactor.swift
//  Homework
//
//  Created by SangDo on 2020/09/06.
//  Copyright © 2020 SangDo. All rights reserved.
//

import ReactorKit
import RxSwift

class ViewControllerReactor: Reactor {
    
    enum Action {
        case getKeywords
        case setText(String)
        case getSearch(Int, Type)
        case getSort(Int)
    }
    
    enum Mutaion {
        case setTextData(String)
        case getData([Search.ResponseData])
        case getSortData([Search.ResponseData])
        case pagingData([Search.ResponseData])
        case getKeyword([Word])
        case setSelect(Bool)
        case setType(Type)
        case isCafeEnd(Bool)
        case isBlogEnd(Bool)
        case isHidden(Bool)
        case dim(String)
        case isLodingBar(Bool)
    }
    
    struct State {
        var text: String = ""
        var page: Int = 0
        var isCafePageEnd: Bool = false
        var isBlogPageEnd: Bool = false
        var items: [Search.ResponseData] = []
        var isSelect: Bool = true
        var type: Type = Type.All
        var searchWords: [Word] = []
        var isKeywordHidden: Bool = true
        var urlStr: String = ""
        var isLoding: Bool = true
    }
    
    var initialState: State
    let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
        self.initialState = State()
    }
    
    func transform(mutation: Observable<ViewControllerReactor.Mutaion>) -> Observable<ViewControllerReactor.Mutaion> {
        let eventMutation = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .click(let urlStr):
                return .just(.dim(urlStr))
            }
        }
        return Observable.merge(mutation, eventMutation)
    }
    
    func mutate(action: ViewControllerReactor.Action) -> Observable<ViewControllerReactor.Mutaion> {
        switch action {
        case .getKeywords:
            return Observable.concat([
                service.fetch().map { .getKeyword($0) },
                Observable.just(.isHidden(false))
            ])
        case .setText(let text):
            return Observable.just(.setTextData(text))
        case .getSearch (let page, let type):
            _ = service.save(title: currentState.text)
            
            switch type {
            case .All:
                let cafeService = service.search("cafe", currentState.text, page)
                let blogService = service.search("blog", currentState.text, page)
                
                if page == 1 {
                    return Observable.concat([
                        Observable.just(.isLodingBar(false)),
                        Observable.combineLatest(cafeService.map { $0.documents }, blogService.map { $0.documents }, resultSelector: { return $0+$1 })
                            .map({ (items) -> [Search.ResponseData] in
                                return items.sorted(by: { (item1, item2) -> Bool in
                                    return item1.title < item2.title
                                })
                            }).map { .getData($0) },
                        cafeService.map { .isCafeEnd($0.meta.is_end) },
                        blogService.map { .isBlogEnd($0.meta.is_end) },
                        Observable.just(.setType(Type.All)),
                        Observable.just(.isHidden(true)),
                        service.fetch().map { .getKeyword($0) },
                        Observable.just(.isLodingBar(true))
                    ])
                } else {
                    return Observable.concat([
                        Observable.just(.isLodingBar(false)),
                        Observable.combineLatest(cafeService.map { $0.documents }, blogService.map { $0.documents }, resultSelector: { return $0+$1 })
                            .map({ (items) -> [Search.ResponseData] in
                                return items.sorted(by: { (item1, item2) -> Bool in
                                    return item1.title < item2.title
                                })
                            }).map { .pagingData($0) },
                        cafeService.map { .isCafeEnd($0.meta.is_end) },
                        blogService.map { .isBlogEnd($0.meta.is_end) },
                        Observable.just(.setType(Type.All)),
                        Observable.just(.isLodingBar(true))
                    ])
                }
            case .Cafe:
                let cafeService = service.search("cafe", currentState.text, page)
                if page == 1 {
                    return Observable.concat([
                        Observable.just(.isLodingBar(false)),
                        cafeService
                            .map { $0.documents }
                            .map { $0.sorted(by: { $0.title < $1.title }) }
                            .map { .getData($0) },
                        Observable.just(.setSelect(true)),
                        Observable.just(.setType(Type.Cafe)),
                        Observable.just(.isLodingBar(true))
                    ])
                } else {
                    return Observable.concat([
                        Observable.just(.isLodingBar(false)),
                        cafeService
                            .map { $0.documents }
                            .map { $0.sorted(by: { $0.title < $1.title }) }
                            .map { .pagingData($0) },
                        Observable.just(.setSelect(true)),
                        Observable.just(.setType(Type.Cafe)),
                        Observable.just(.isLodingBar(true))
                    ])
                }
            default:
                let blogService = service.search("blog", currentState.text, page)
                if page == 1 {
                    return Observable.concat([
                        Observable.just(.isLodingBar(false)),
                        blogService
                            .map { $0.documents }
                            .map { $0.sorted(by: { $0.title < $1.title }) }
                            .map { .getData($0) },
                        Observable.just(.setSelect(true)),
                        Observable.just(.setType(Type.Blog)),
                        Observable.just(.isLodingBar(true))
                    ])
                } else {
                    return Observable.concat([
                        Observable.just(.isLodingBar(false)),
                        blogService
                            .map { $0.documents }
                            .map { $0.sorted(by: { $0.title < $1.title }) }
                            .map { .pagingData($0) },
                        Observable.just(.setSelect(true)),
                        Observable.just(.setType(Type.Blog)),
                        Observable.just(.isLodingBar(true))
                    ])
                }
            }
        case .getSort (let index):
            switch index {
            case 0:
                return Observable.just(.getSortData(currentState.items.sorted(by: { (item1, item2) -> Bool in
                    return item1.title < item2.title
                })))
            case 1:
                return Observable.just(.getSortData(currentState.items.sorted(by: { (item1, item2) -> Bool in
                    return item1.datetime > item2.datetime
                })))
            default:
                return .empty()
            }
        }
    }
    
    func reduce(state: ViewControllerReactor.State, mutation: ViewControllerReactor.Mutaion) -> ViewControllerReactor.State {
        var newState = state
        switch mutation {
        case .setTextData(let text):
            newState.text = text
        case .getData(let data):
            newState.items = data
        case .pagingData(let data):
            var currentItems = currentState.items
            currentItems.append(contentsOf: data)
            newState.items = currentItems
        case .setSelect(let bool):
            newState.isSelect = bool
        case .getSortData(let data):
            newState.items = data
        case .setType(let type):
            newState.type = type
        case .isCafeEnd(let bool):
            newState.isCafePageEnd = bool
        case .isBlogEnd(let bool):
            newState.isBlogPageEnd = bool
        case .getKeyword(let searchWord):
            newState.searchWords = searchWord
        case .isHidden(let bool):
            newState.isKeywordHidden = bool
        case .dim(let urlStr):
            newState.urlStr = urlStr
        case .isLodingBar(let bool):
            newState.isLoding = bool
        }
        return newState
    }
    
    func detailViewCreating(_ item: Search.ResponseData) -> DetailViewControllerReactor {
        return DetailViewControllerReactor(service: service, item: item)
    }
}


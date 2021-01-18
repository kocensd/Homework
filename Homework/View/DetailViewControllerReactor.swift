//
//  DetailViewControllerReactor.swift
//  Homework
//
//  Created by SangDo on 2020/09/08.
//  Copyright © 2020 SangDo. All rights reserved.
//

import ReactorKit
import RxSwift
//test

//searchTest
class DetailViewControllerReactor: Reactor {
    
    
    enum Action {
        case move
    }
    
    enum Mutaion {
        case movePage(Bool)
    }
    
    struct State {
        var item: Search.ResponseData?
        var isMove: Bool = false
        
        init(item: Search.ResponseData) {
            self.item = item
        }
    }
    
    var initialState: State
    let service: ServiceProtocol
    
    init(service: ServiceProtocol, item: Search.ResponseData) {
        self.service = service
        self.initialState = State(item: item)
    }
    
    func mutate(action: DetailViewControllerReactor.Action) -> Observable<DetailViewControllerReactor.Mutaion> {
        switch action {
        case .move:
            return service.moveUrl(currentState.item?.url ?? "")
                .map { _ in.movePage(true) }
        }
    }
       
    func reduce(state: DetailViewControllerReactor.State, mutation: DetailViewControllerReactor.Mutaion) -> DetailViewControllerReactor.State {
        var newState = state
        switch mutation {
        case .movePage(let bool):
            newState.isMove = bool
        }
        return newState
    }
}

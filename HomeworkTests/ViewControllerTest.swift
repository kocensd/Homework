//
//  ViewControllerTest.swift
//  HomeworkTests
//
//  Created by SangDo on 2020/09/10.
//  Copyright © 2020 SangDo. All rights reserved.
//

import XCTest
@testable import Homework

import RxSwift
import RxTest
import RxExpect
import RxCocoa

class ViewControllerTest: XCTestCase {

    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        //삭제 처리 후
        DbProvider.shared.delete()
    }
    
    func testGetKeyword() {
        let test = RxExpect()
        let serviceProvider = Service()
        let reactor = test.retain(ViewControllerReactor(service: serviceProvider))
        
        _ = serviceProvider.save(title: "Test")
        
        reactor.action.onNext(.getKeywords)
        XCTAssertEqual(reactor.currentState.searchWords.count, 1)
    }
    
    func testGetText() {
        let test = RxExpect()
        let serviceProvider = Service()
        let reactor = test.retain(ViewControllerReactor(service: serviceProvider))
        
        reactor.action.onNext(.setText("test"))
        XCTAssertEqual(reactor.currentState.text, "test")
    }

    func testGetSearch() {
        let test = RxExpect()
        let serviceProvider = Service()
        let reactor = test.retain(ViewControllerReactor(service: serviceProvider))
        
        test.input(reactor.action, [Recorded.next(100, .getSearch(1, Type.All))])
        
        let expect = reactor.state.map { $0.isLoding }
        test.assert(expect) { event in
            XCTAssertEqual(event, [
                Recorded.next(0, true),
                Recorded.next(100, false), //combineLatest
                Recorded.next(100, false), //just
                Recorded.next(100, false), //just
                Recorded.next(100, false), //service.fetch()
                Recorded.next(100, true)
            ])
        }
    }
}

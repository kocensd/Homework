//
//  DbProvider.swift
//  Homework
//
//  Created by SangDo on 2020/09/08.
//  Copyright © 2020 SangDo. All rights reserved.
//

import RealmSwift
import RxSwift

class DbProvider {
    static var shared = DbProvider()
    var realm = try! Realm()
    
    func save(_ words: Word) {
        try! realm.write {
            realm.add(words)
        }
    }
    
    func load() -> [Word] {
        let data = realm.objects(Word.self)
        return Array(data)
        
    }
    
    func delete() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("\(error)")
        }
    }
}


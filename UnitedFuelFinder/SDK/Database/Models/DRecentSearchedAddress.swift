//
//  DSearchedItems.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/11/23.
//

import Foundation
import RealmSwift

public struct SearchedAddress: Objectify {
    var title: String
    var date: Date
    
    var asObject: Object {
        DRecentSearchedAddress(title: title, date: date)
    }
}

public class DRecentSearchedAddress: Object, Identifiable {
    @Persisted(primaryKey: true) var title: String
    @Persisted var date: Date
    public init(title: String, date: Date) {
        self.date = date
        super.init()
        self.title = title
    }
    
    public override init() {
        super.init()
    }
}

extension DRecentSearchedAddress {
    static func add(_ item: SearchedAddress) {
        DataBase.writeThread.async {
            Realm.new?.trySafeWrite({ realm in
                realm.add(item.asObject, update: .modified)
            })
        }
    }

    //    sorted by inserted date
    static func all() -> Results<DRecentSearchedAddress> {
        Realm.new!.objects(DRecentSearchedAddress.self).sorted(byKeyPath: "date", ascending: false)    
    }
}

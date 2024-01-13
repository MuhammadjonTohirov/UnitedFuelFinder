//
//  State.swift
//  USDK
//
//  Created by applebro on 26/10/23.
//

import Foundation
import RealmSwift

public class DState: Object, StateObjectProtocol, Identifiable {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    
    public init(id: String, name: String) {
        self.name = name
        super.init()

        self.id = id
    }
    
    public override init() {
        super.init()
    }
    
    static func allStates() -> Results<DState> {
        Realm.new!.objects(DState.self)
    }
    
    static func clear() {
        Realm.new?.trySafeWrite({ realm in
            let objs = realm.objects(DState.self)
            realm.delete(objs)
        })
    }
    
    static func item(id: String) -> DState? {
        guard let realm = Realm.new else {
            return nil
        }
        
        return realm.object(ofType: DState.self, forPrimaryKey: id)
    }
    
    var asModel: StateItem {
        StateItem(id: id, name: name)
    }
}

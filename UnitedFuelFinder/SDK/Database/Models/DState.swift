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
}

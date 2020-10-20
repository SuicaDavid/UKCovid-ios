//
//  SetExtension.swift
//  UKCovid-ios
//
//  Created by Suica on 19/10/2020.
//

import Foundation

extension Set {
    @discardableResult mutating func insert(_ newMembers: [Set.Element]) -> [(inserted: Bool, memberAfterInsert: Set.Element)] {
        var returnArray: [(inserted: Bool, memberAfterInsert: Set.Element)] = []
        newMembers.forEach { (member) in
            returnArray.append(self.insert(member))
        }
        return returnArray
    }
}

//
//  AppState.swift
//  ReactiveTerms
//
//  Created by André Gimenez Faria on 27/04/2018.
//  Copyright © 2018 André Gimenez Faria. All rights reserved.
//

import ReSwift
import RxSwift

enum TermsFetchState: StateType {
    case loading
    case loaded([Term])
    case error(TermFetchError)
}

enum TermsListDisplayState {
    case empty
    case ready
    case needsToRetry
}

typealias TermListItem = (name: String, content: String, accepted: Bool)

struct TermListStateNew: StateType {
    var displayState = TermsListDisplayState.empty
    var items: [TermListItem] = []
    var canProcceed: Bool {
        if items.isEmpty {
            return false
        }
        return items.filter { $0.accepted == false }.count == 0
    }
}

struct AppState: StateType {
    var termsFetchState = TermsFetchState.loading
    var termListState = TermListStateNew()
}

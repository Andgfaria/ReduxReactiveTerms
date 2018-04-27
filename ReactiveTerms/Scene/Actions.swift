//
//  Actions.swift
//  ReactiveTerms
//
//  Created by André Gimenez Faria on 27/04/2018.
//  Copyright © 2018 André Gimenez Faria. All rights reserved.
//

import ReSwift

enum TermsFetchAction: Action {
    case load
    case loaded([Term])
    case failed(TermFetchError)
}

enum TermsListAction: Action {
    case load
    case accept(Int)
    case showRetry
}

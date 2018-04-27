//
//  Reducers.swift
//  ReactiveTerms
//
//  Created by André Gimenez Faria on 27/04/2018.
//  Copyright © 2018 André Gimenez Faria. All rights reserved.
//

import ReSwift
import RxSwift

func fetchReducer(action: Action, state: AppState?) -> AppState {
    var appState = state ?? AppState()
    
    guard let fetchAction = action as? TermsFetchAction else { return appState }
    
    switch fetchAction {
    case TermsFetchAction.load:
        TermFetcher.shared.fetchTerms()
        appState.termsFetchState = .loading
    case TermsFetchAction.loaded(let terms):
        appState.termsFetchState = .loaded(terms)
    case TermsFetchAction.failed(let error):
        appState.termsFetchState = .error(error)
    }
    
    return appState
}

func listReducer(action: Action, state: AppState?) -> AppState {
    var appState = state ?? AppState()
    
    guard let listAction = action as? TermsListAction else { return appState }
    
    switch listAction {
    case .load:
        if case let TermsFetchState.loaded(terms) = appState.termsFetchState {
            appState.termListState.items = terms.map {
                return (name: $0.name, content: $0.content, accepted: false)
            }
            appState.termListState.displayState = .ready
        }
        else {
            appState.termListState.displayState = .needsToRetry
        }
    case .accept(let index):
        appState.termListState.items[index].accepted = true
    case .showRetry:
        appState.termListState.displayState = .needsToRetry
    }
    return appState
}

func mainReducer(action: Action, state: AppState?) -> AppState {
    return AppState(termsFetchState: fetchReducer(action: action, state: state).termsFetchState,
                    termListState: listReducer(action: action, state: state).termListState)
}

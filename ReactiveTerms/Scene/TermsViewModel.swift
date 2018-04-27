//
//  TermsViewModel.swift
//  ReactiveTerms
//
//  Created by André Gimenez Faria on 27/04/2018.
//  Copyright © 2018 André Gimenez Faria. All rights reserved.
//

import ReSwift
import RxSwift

class TermsViewModel {
    
    var displayState = Variable(store.state.termListState.displayState)

    var items = Variable<[TermListItem]>([])

    var canProceed = Variable(store.state.termListState.canProcceed)
    
    init() {
        store.subscribe(self) { $0.select { $0.termListState } }
        store.dispatch(TermsFetchAction.load)
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
}

extension TermsViewModel: StoreSubscriber {
    
    typealias StoreSubscriberStateType = TermListStateNew

    func newState(state: TermListStateNew) {
        displayState.value = state.displayState
        items.value = state.items
        canProceed.value = state.canProcceed
    }
}

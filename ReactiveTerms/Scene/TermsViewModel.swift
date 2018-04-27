//
//  TermsViewModel.swift
//  ReactiveTerms
//
//  Created by André Gimenez Faria on 27/04/2018.
//  Copyright © 2018 André Gimenez Faria. All rights reserved.
//

import RxSwift

enum TermsListState {
    case loading
    case loaded
    case error
}

class TermsViewModel {
    
    var state = Variable(TermsListState.loading)
    
    var terms = Variable<[(title: String, content: String, accepted: Bool)]>([])
    
    var selection = PublishSubject<Int>()
    
    var canProceed: Observable<Bool>
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.canProceed = terms.asObservable().map { $0.reduce(true) { $0 && $1.accepted } }

        state.asObservable()
             .filter { $0 == .loading }
             .concatMap { _ in TermFetcher.terms() }
             .subscribe(
              onNext: { [weak self] in
                self?.terms.value = $0.map {
                    (title: $0.name, content: $0.content, accepted: false)
                }
                self?.state.value = .loaded
              },
              onError: { [weak self] _ in
                self?.state.value = .error
              })
             .disposed(by: disposeBag)
        
        selection.asObserver()
                  .subscribe(onNext: { [weak self] index in
                        self?.terms.value[index].accepted = true
                  })
                  .disposed(by: disposeBag)
        
    }
    
}

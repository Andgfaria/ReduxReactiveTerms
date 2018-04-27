//
//  TermFetcher.swift
//  ReactiveTerms
//
//  Created by André Gimenez Faria on 27/04/2018.
//  Copyright © 2018 André Gimenez Faria. All rights reserved.
//

import Foundation
import RxSwift

enum TermFetchError: Error {
    case missingJson
    case badJson
    case unknown
}

struct TermFetcher {
    
    static let shared = TermFetcher()
    
    private let disposeBag = DisposeBag()
    
    func fetchTerms(from jsonName: String = "terms") {
        terms(from: jsonName)
            .subscribe(onNext: { terms in
                store.dispatch(TermsFetchAction.loaded(terms))
                store.dispatch(TermsListAction.load)
            },
            onError: { error in
                DispatchQueue.main.async {
                    store.dispatch(TermsFetchAction.failed(error as? TermFetchError ?? .unknown))
                    store.dispatch(TermsListAction.showRetry)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func terms(from jsonName: String = "terms") -> Observable<[Term]> {
        guard let filePath = Bundle.main.path(forResource: jsonName, ofType: "json") else {
            return Observable.error(TermFetchError.missingJson)
        }
        let url = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: url)
            let terms = try JSONDecoder().decode([Term].self, from: data)
            return Observable.just(terms).delay(5.0, scheduler: MainScheduler.instance)
        }
        catch {
            return Observable.error(TermFetchError.badJson)
        }
    }
    
    private init() { }

}

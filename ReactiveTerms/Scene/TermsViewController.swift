//
//  TermsViewController.swift
//  ReactiveTerms
//
//  Created by André Gimenez Faria on 27/04/2018.
//  Copyright © 2018 André Gimenez Faria. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class TermsViewController: UIViewController {

    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak private var tableView: UITableView!
    
    @IBOutlet weak private var retryButton: UIButton!
    
    @IBOutlet weak private var proceedBarButtonItem: UIBarButtonItem!
    
    private let viewModel = TermsViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindState()
        bindTableView()
        bindProceedButton()
    }

}

extension TermsViewController {

    private func bindState() {
        viewModel.displayState
                 .asObservable()
                 .subscribe(onNext: { [weak self] state in
                    self?.activityIndicator.isHidden = state != .empty
                    self?.tableView.isHidden = state != .ready
                    self?.retryButton.isHidden = state != .needsToRetry
                 })
                 .disposed(by: disposeBag)
    }

    private func bindTableView() {
        viewModel.items
                 .asObservable()
                 .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, item, cell in
                    cell.textLabel?.text = item.name
                    cell.detailTextLabel?.text = item.content
                    cell.accessoryType = item.accepted ? .checkmark : .none
                }
                .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .subscribe() { event in
                if let indexPath = event.element {
                    store.dispatch(TermsListAction.accept(indexPath.row))
                }
            }
            .disposed(by: disposeBag)
    }

    private func bindProceedButton() {
        viewModel.canProceed.asObservable().bind(to: proceedBarButtonItem.rx.isEnabled).disposed(by: disposeBag)
    }

}

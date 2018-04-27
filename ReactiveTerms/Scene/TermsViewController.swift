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
        viewModel.state
                 .asObservable()
                 .subscribe(onNext: { [weak self] state in
                    self?.activityIndicator.isHidden = state != .loading
                    self?.tableView.isHidden = state != .loaded
                    self?.retryButton.isHidden = state != .error
                 })
                 .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        viewModel.terms
                 .asObservable()
                 .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, termRow, cell in
                    cell.textLabel?.text = termRow.title
                    cell.detailTextLabel?.text = termRow.content
                    cell.accessoryType = termRow.accepted ? .checkmark : .none
                }
                .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe() { [weak self] event in
                if let indexPath = event.element {
                    self?.viewModel.selection.onNext(indexPath.row)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindProceedButton() {
        viewModel.canProceed.bind(to: proceedBarButtonItem.rx.isEnabled).disposed(by: disposeBag)
    }
    
}

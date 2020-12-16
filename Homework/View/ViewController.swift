//
//  ViewController.swift
//  Homework
//
//  Created by SangDo on 2020/09/06.
//  Copyright © 2020 SangDo. All rights reserved.
//

import UIKit
import Alamofire
import ReactorKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, StoryboardView {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var selectView: UIStackView!
    @IBOutlet weak var typeSelectBtn: UIButton!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var cafeBtn: UIButton!
    @IBOutlet weak var blogBtn: UIButton!
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var page: Int = 1
    let firstPage: Int = 1
    var urls: [String] = []
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DbProvider.shared.delete()
        tableView.prefetchDataSource = self
    }
    
    deinit {
        print("ViewControllerDeInit")
    }
    
    func bind(reactor: ViewControllerReactor) {
        self.typeSelectBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.selectView.isHidden = false
                self?.dimView.isHidden = false
            }).disposed(by: disposeBag)
        
        self.searchBar.rx.text.orEmpty
            .map (Reactor.Action.setText)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.searchBar.searchTextField.rx.controlEvent(.editingDidBegin)
            .map { Reactor.Action.getKeywords }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.searchBtn.rx.tap
            .map { _ in self.searchBar.searchTextField.resignFirstResponder() }
            .map { (self.firstPage, Type.All) }
            .map (Reactor.Action.getSearch)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.allBtn.rx.tap
            .map { (self.firstPage, Type.All) }
            .map (Reactor.Action.getSearch)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.cafeBtn.rx.tap
            .map { (self.firstPage, Type.Cafe) }
            .map (Reactor.Action.getSearch)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.blogBtn.rx.tap
            .map { (self.firstPage, Type.Blog) }
            .map (Reactor.Action.getSearch)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.sortBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.alertSort()
            }).disposed(by: disposeBag)
        
        self.searchTableView.rx.modelSelected(Word.self)
            .map { $0.searchWord }
            .map (Reactor.Action.setText)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.searchTableView.rx.modelSelected(Word.self)
            .map { _ in self.searchBar.searchTextField.resignFirstResponder() }
            .map { _ in (self.firstPage, Type.All) }
            .map (Reactor.Action.getSearch)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoding }
            .distinctUntilChanged()
            .bind(to: self.indicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.urlStr }
            .subscribe(onNext: { url in
                self.urls.append(url)
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.text }
            .subscribe(onNext: { text1 in
                self.searchBar.searchTextField.text = text1
        }).disposed(by: disposeBag)
        
        reactor.state
            .map { ($0.isKeywordHidden, $0.text) }
            .subscribe(onNext: { (bol, text) in
                self.searchTableView.isHidden = bol
            }).disposed(by: disposeBag)
        
        reactor.state
            .observeOn(MainScheduler.instance)
            .map { $0.isSelect }
            .bind(to: self.selectView.rx.isHidden,
                  self.dimView.rx.isHidden
                  )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { "\($0.type)" }
            .bind(to: self.typeSelectBtn.rx.title())
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.items }
            .observeOn(MainScheduler.instance)
            .bind(to: self.tableView.rx.items(cellIdentifier: "cell", cellType: ListTableViewCell.self)) { indexPath, list, cell in
                DispatchQueue.main.async {
                    cell.setData(list, self.urls)
                }
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.searchWords }
            .bind(to: self.searchTableView.rx.items(cellIdentifier: "wordCell")) { indexPath, word, cell in
                cell.textLabel?.textColor = .systemBlue
                cell.textLabel?.text = word.searchWord
        }.disposed(by: disposeBag)
        
        self.tableView.rx.modelSelected(Search.ResponseData.self)
        .map(reactor.detailViewCreating)
        .subscribe(onNext: { [weak self] detailReactor in
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                vc.reactor = detailReactor
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    func addData() {
        self.page += 1
        Observable.just(Void())
            .map { (self.page, (self.reactor?.currentState.type)!) }
            .map (Reactor.Action.getSearch)
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    func alertSort() {
        let actions: [UIAlertController.AlertAction] = [
            .action(title: "title"),
            .action(title: "date"),
            .action(title: "취소", style: .cancel)
        ]
        if UIDevice.current.userInterfaceIdiom == .pad {
            UIAlertController
                .present(in: self, title: nil, message: nil, style: .actionSheet, type: "ipad", actions: actions)
                .map { Reactor.Action.getSort($0) }
                .bind(to: reactor!.action)
                .disposed(by: disposeBag)
        } else {
            UIAlertController
                .present(in: self, title: nil, message: nil, style: .actionSheet, type: "iphone", actions: actions)
                .map { Reactor.Action.getSort($0) }
                .bind(to: reactor!.action)
                .disposed(by: disposeBag)
        }
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row == (reactor?.currentState.items.count)! - 1  && (!(reactor?.currentState.isCafePageEnd)! || !(reactor?.currentState.isBlogPageEnd)!) {
                self.addData()
            }
        }
    }
}

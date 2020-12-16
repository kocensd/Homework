//
//  DetailViewController.swift
//  Homework
//
//  Created by SangDo on 2020/09/08.
//  Copyright © 2020 SangDo. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController, StoryboardView {
    
    @IBOutlet weak var thumImageView: UIImageView!
    @IBOutlet weak var typeNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var urlBtn: UIButton!
    @IBOutlet weak var moveBtn: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("DetailViewControllerDeInit")
    }
    
    func bind(reactor: DetailViewControllerReactor) {
        self.moveBtn.rx.tap
            .map { Reactor.Action.move }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isMove }
            .subscribe(onNext: { bool in
                if bool {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
                        vc.naviTitle = reactor.currentState.item?.title ?? ""
                        vc.urlStr = reactor.currentState.item?.url ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.item }
            .subscribe(onNext: { [weak self] data in
                self?.navigationItem.title = data?.cafename != "" ? "CAFE" : "BLOG"
                self?.thumImageView.sd_setImage(with: URL(string: data?.thumbnail ?? ""), placeholderImage: UIImage(named: "no_img.gif"))
                self?.typeNameLabel.text = data?.cafename != "" ? data?.cafename : data?.blogname
                self?.titleLabel.text = checkValid(data?.title ?? "")
                self?.contentText.text = checkValid(data?.contents ?? "")
                self?.dateLabel.text = changeDate(data?.datetime ?? "")
                self?.urlLabel.text = data?.url
            }).disposed(by: disposeBag)
    }
}

//
//  ViewController.swift
//  RxTest
//
//  Created by apple on 2022/1/12.
//

import UIKit
import RxSwift
import RxCocoa
import TinyConstraints

struct Product {
    let title: String
}

struct ProductViewModel {
    var items = PublishSubject<[Product]>()
    func fetchItems() {
        let products = [
            Product(title: "A"),
            Product(title: "B"),
            Product(title: "C")
        ]
        items.onNext(products)
        items.onCompleted()
    }
}

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    var tableView: UITableView!
    let viewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView = UITableView.init()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        setUpTableView()
    }
    
    func setUpTableView() {
    
        tableView.center(in: view)
        tableView.width(300)
        tableView.height(300)
        
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, item, cell in
            cell.textLabel?.text = item.title
        }.disposed(by: disposeBag)

        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: disposeBag)
        
        viewModel.fetchItems()
    }
}


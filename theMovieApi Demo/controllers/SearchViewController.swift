//
//  SearchViewController.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 26.02.2021.
//

import UIKit

class SearchViewController: BaseController {

    var delegate:SearchControllerDelegate?

    @IBOutlet weak private var viewBlur:UIView!

    @IBOutlet weak private var tableView:UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "\(MovieTableViewCell.self)", bundle: nil), forCellReuseIdentifier:"\(MovieTableViewCell.self)" )
        }
    }

    private var viewModel:SearchControllerViewModel!


    override func viewDidLoad() {
        super.viewDidLoad()
        handleTapGesture()
        // Do any additional setup after loading the view.
        prepareViewModel()

    }

    func prepareViewModel(){

        self.viewModel =  SearchControllerViewModel()
        self.viewModel.bindViewModelToController = { [weak self] in
            guard let `self` = self else { return }
            self.tableView.isHidden = self.viewModel.datas.count <= 0
            self.tableView.reloadData()
         }
        
        self.viewModel.onErrorHandling = { [weak self] message in
            guard let `self` = self else { return }
            self.presentSingleActionAlert(message: message)
        }
    }
    func searchWith(_ keyword:String) {
        self.viewModel.callFuncToGetSearch(keyword: keyword)
    }

    func handleTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.gestureAppend))
        self.viewBlur.addGestureRecognizer(tapGesture)
    }

    @objc func gestureAppend(){
        self.view.removeFromSuperview()
        self.removeFromParent()
        delegate?.pageClosed()
    }

}
extension SearchViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" ,for: indexPath)
        let data = viewModel.getData(at: indexPath)
        cell.textLabel?.text = data.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.movieSelected(data: self.viewModel.getData(at: indexPath))
        self.gestureAppend()
    }

}

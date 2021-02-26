//
//  HomeViewController.swift
//  theMovieApi Demo
//
//  Created by Mustafa MEDENi on 25.02.2021.
//

import UIKit


final class ListViewController: BaseController {

    @IBOutlet weak private var collectionPageControl:UIPageControl!
    @IBOutlet weak private var searchBar:UISearchBar!{
        didSet{
            searchBar.delegate = self
            
        }
    }
    @IBOutlet weak private var collectionView:UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "\(MoviePosterCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(MoviePosterCollectionViewCell.self)")
        }
    }
    @IBOutlet weak private var tableView:UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "\(MovieTableViewCell.self)", bundle: nil), forCellReuseIdentifier:"\(MovieTableViewCell.self)" )
        }
    }

    private var viewModel:ListControllerViewModel!

    private var searchController:SearchViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViewModel()
        prepareSearchBar()

    }

    func prepareViewModel(){

        self.viewModel =  ListControllerViewModel()
        self.viewModel.bindViewModelToController = { [weak self] in
            guard let `self` = self else { return }
            self.tableView.reloadData()
            self.collectionView.reloadData()
            self.collectionPageControl.numberOfPages = self.viewModel.nowPlayingDatas.count
        }
        self.viewModel.onErrorHandling = { [weak self] message in
            guard let `self` = self else { return }
            self.presentSingleActionAlert(message: message)
        }
    }

    func prepareSearchBar(){
        self.navigationItem.titleView = searchBar
    }


}
extension ListViewController : UISearchBarDelegate,SearchControllerDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchController?.searchWith(searchText)
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchController = UIViewController.create(type: .search) as! SearchViewController
        guard let vc = self.searchController else { return false }
        vc.delegate = self
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)

        return true
    }

    func pageClosed() {
        self.searchBar.endEditing(true)
    }

    func handleFail(error: String) {
        self.presentSingleActionAlert(message: error)
    }

    func movieSelected(data:Movie){
        guard let id = data.id , let vc = MovieDetailViewController.getInstance(movieID: id ) else { return }
        self.searchBar.text = nil
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController?.gestureAppend()
    }
}

extension ListViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.upComingDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MovieTableViewCell.self)",for: indexPath) as? MovieTableViewCell else { return UITableViewCell()}
        let data = self.viewModel.getTableCellViewModel(at: indexPath)
        cell.prepareWith(data)

        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MovieTableViewCell else { return }
        cell.loadImage()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel.upComingDatas[indexPath.row]
        guard let id = data.id , let vc = MovieDetailViewController.getInstance(movieID: id ) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension ListViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.nowPlayingDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MoviePosterCollectionViewCell.self)", for: indexPath) as? MoviePosterCollectionViewCell else { return UICollectionViewCell()}
        let data = self.viewModel.getCollectionCellViewModel(at: indexPath)
        cell.prepareWith(data)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MoviePosterCollectionViewCell else { return }
        cell.loadImage()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.viewModel.nowPlayingDatas[indexPath.row]
        guard let id = data.id , let vc = MovieDetailViewController.getInstance(movieID: id ) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / (collectionView.frame.width)
        collectionPageControl.currentPage = Int(scrollPos)
    }


}

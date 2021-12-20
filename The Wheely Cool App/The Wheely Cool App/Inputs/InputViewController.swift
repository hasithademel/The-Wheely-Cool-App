//
//  InputViewController.swift
//  The Wheely Cool App
//
//  Created by Hasitha De Mel on 20/12/21.
//

import UIKit
import Combine

class InputViewController: UIViewController {

    // MARK: - Properties
    let viewModel: InputsViewModel = InputsViewModel()
    private var cancellables: Set<AnyCancellable> = []
    @IBOutlet weak var tableContainerView: UIView!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(tableView)
        NSLayoutConstraint(item: tableView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: tableContainerView, attribute: .centerX,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: tableView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: tableContainerView, attribute: .leading,
                           multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView,
                           attribute: .trailing,
                           relatedBy: .equal, toItem: tableContainerView,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top,
                           relatedBy: .equal,
                           toItem: tableContainerView,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: tableView,
                           attribute: .bottom,
                           relatedBy: .equal, toItem: tableContainerView,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        
        
        return tableView
    }()

    
    private func initView() {
        self.view.backgroundColor = .white
        
        tableView.register(UINib(nibName: OptionsTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: OptionsTableViewCell.cellIdentifier)
        self.tableContainerView.addSubview(tableView)
    }
    
    private func initBinding() {
        viewModel.$options
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {_ in self.renderOptions()})
            .store(in: &cancellables)
    }
    
    private func renderOptions() {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
        viewModel.loadData()
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        if viewModel.numberOfOptions() == 10 {
            showAlert(message: "Limit reached")
            return
        }
        
        let alert = UIAlertController(title: "New Option", message: "Enter your option", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your option"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0], let option = textField.text {
                DispatchQueue.main.async {
                    self.viewModel.addOption(option: option)
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if viewModel.numberOfOptions() < 2 {
            showAlert(message: "Please add atleast two options")
            return
        }
        
        let wheelVC = WheelViewContoller(nibName: "WheelViewContoller", bundle: nil)
        let viewmodel = WheelViewModel(options: viewModel.allOptions())
        wheelVC.viewModel = viewmodel
        self.navigationController?.pushViewController(wheelVC, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}


extension InputViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfOptions()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableViewCell.cellIdentifier, for: indexPath) as? OptionsTableViewCell {
            let option = viewModel.optionAt(row: indexPath.row)
            cell.setup(option: option)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Delete Option", message: "Are you sure you want to permanently delete \(viewModel.optionAt(row: indexPath.row))?", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.viewModel.deleteOptionAt(index: indexPath.row)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alert.addAction(deleteAction)
            alert.addAction(cancelAction)

            alert.popoverPresentationController?.sourceView = self.view
            self.present(alert, animated: true, completion: nil)
        }
    }
}

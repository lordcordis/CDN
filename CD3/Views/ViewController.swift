//
//  ViewController.swift
//  CD3
//
//  Created by wheatley on 28.08.23.
//

import UIKit
import SwiftUI
import CoreData


extension ViewController: dismissViewDelegate {
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    
    func appendNewNoteToSnapshot(note: NoteEntity) {
        appendItemToSnapshot(item: note)
    }
    
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}

class ViewController: UIViewController, UITableViewDelegate {
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        return table
    }()
    
    var addNewNoteButton: UIBarButtonItem!
    var showTagsButton: UIBarButtonItem!
    var dataSource: UITableViewDiffableDataSource<TableViewSection, NoteEntity>!
    var viewModel: ViewControllerViewModel!
    
//    func addSampleTag() {
//        let tag = TagEntity(context: viewModel.manager.context)
//        tag.name = "Sample tag 2"
//        tag.notes = NSSet(array: viewModel.notes)
//        viewModel.manager.context.insert(tag)
//        viewModel.manager.save()
//    }
    
    override func viewDidLoad() {
        viewModel = ViewControllerViewModel()
        title = "Core Data Notes"
        setupTableView()
        setupDataSource()
        setupSnapshot()
        setupTabBar()
        showTagsButton = UIBarButtonItem(image: UIImage(systemName: "tag"), style: .plain, target: self, action: #selector(showSheetView))
        addNewNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        navigationItem.rightBarButtonItem = addNewNoteButton
        navigationItem.leftBarButtonItem = showTagsButton
        
//        addSampleTag()
        
        
        super.viewDidLoad()
    }
    
    @objc func addNewNote() {
        viewModel.createNewItem(viewController: self)
    }
    
    @objc func showSheetView() {
        let viewModel = TagsViewModel()
        viewModel.delegate = self
        
        let sheetController = UIHostingController(rootView: TagsView(viewModel: viewModel))
        
        let viewControllerToPresent = sheetController
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.largestUndimmedDetentIdentifier = .none
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 20
        }
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.bounds
        tableView.delegate = self
//        tableView.allowsSelection = false
        view.addSubview(tableView)
    }
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<TableViewSection, NoteEntity>(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.text
            
            let description = self.viewModel.tagsDescriptionForNote(note: itemIdentifier)
            
            configuration.secondaryText = description
            cell.contentConfiguration = configuration
            return cell
        })
    }
    
    func setupTabBar() {
        navigationItem.rightBarButtonItem = addNewNoteButton
    }
    
    func deleteItemFromSnapshot(item: NoteEntity) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([item])
        dataSource.apply(snapshot)
    }
    
    func appendItemToSnapshot(item: NoteEntity) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([item])
        dataSource.apply(snapshot)
    }
    
    func setupSnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.notes)
        dataSource?.apply(snapshot)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let viewModel = NoteViewModel(note: item, isNewNote: false)
        viewModel.delegate = self
        let container = UIHostingController(rootView: NoteView(viewModel: viewModel))
        navigationController?.pushViewController(container, animated: true)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        var config = header.defaultContentConfiguration()
        guard let identifier = dataSource.sectionIdentifier(for: section) else {return nil}
        
        switch identifier {
        case .main:
            config.text = "Notes"
        case .addNew:
            config.text = "Users"
        }
        
        header.contentConfiguration = config
        return header
        
        
        
        
        
    }
    
    
    func swipeToDelete(indexPath: IndexPath) -> UISwipeActionsConfiguration {
        
        
        let conAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, esc in
            
            guard let item = self.dataSource.itemIdentifier(for: indexPath) else {return}
            
            self.viewModel.deleteItem(item: item)
            self.deleteItemFromSnapshot(item: item)
            
        }
        return UISwipeActionsConfiguration(actions: [conAction])
    }
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return swipeToDelete(indexPath: indexPath)
    }
    
    
}

enum TableViewSection {
    case main, addNew
}


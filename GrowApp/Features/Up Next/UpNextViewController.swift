//
//  UpNextViewController.swift
//  GrowApp
//
//  Created by Ryan Thally on 4/29/21.
//

import Combine
import CoreData
import UIKit

class UpNextViewController: UIViewController {
    // MARK: - Properties
    typealias Section = UpNextViewModel.Section
    typealias Item = UpNextViewModel.Item
    typealias Snapshot = UpNextViewModel.Snapshot

    var viewModel: UpNextViewModel = UpNextViewModel()

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var cancellables: Set<AnyCancellable> = []

    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        cv.backgroundColor = .clear
        cv.delegate = self
        return cv
    }()

    // MARK: - View Life Cycle
    override func loadView() {
        super.loadView()
        setupViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = makeDataSource()

        title = "Up Next"

        viewModel.snapshot
            .sink {[weak self] snapshot in
                self?.dataSource.apply(snapshot)
            }
            .store(in: &cancellables)
    }

    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

private extension UpNextViewController {
    func makeLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: config)
    }

    func makeTaskCellRegistration() -> UICollectionView.CellRegistration<TaskCalendarListCell, Item> {
        UICollectionView.CellRegistration<TaskCalendarListCell, Item> {[weak self] cell, indexPath, item in
            cell.updateWithText(item.title, secondaryText: item.subtitle, icon: item.icon, daysLate: item.daysLate)

            if item.isChecked {
                cell.accessories = [ .checkmark() ]
            } else {
                cell.accessories = [
                    .todoAccessory(actionHandler: {_ in
                        self?.viewModel.markTaskAsComplete(item.careInfo)
                    })
                ]
            }

        }
    }

    func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {[unowned self] cell, elementKind, indexPath in
            guard elementKind == UICollectionView.elementKindSectionHeader else { return }
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            var configuration = UIListContentConfiguration.largeGroupedHeader()
            configuration.text = section.title
            //            configuration.secondaryText = itemCount == 1 ? "\(itemCount) task" : "\(itemCount) tasks"
            cell.contentConfiguration = configuration
        }
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let taskCellRegistration = makeTaskCellRegistration()
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: taskCellRegistration, for: indexPath, item: item)
        }

        let taskHeader = createHeaderRegistration()
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                return collectionView.dequeueConfiguredReusableSupplementary(using: taskHeader, for: indexPath)
            default:
                return nil
            }
        }

        return dataSource
    }
}

extension UpNextViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

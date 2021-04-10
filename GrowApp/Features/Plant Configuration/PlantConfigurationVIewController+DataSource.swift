//
//  PlantConfigurationVIewController+DataSource.swift
//  GrowApp
//
//  Created by Ryan Thally on 2/21/21.
//

import UIKit

// MARK: - Cell Registrations
extension PlantEditorControllerController {
    func createPlantIconCellRegistration() -> UICollectionView.CellRegistration<IconCell, Item> {
        return UICollectionView.CellRegistration<IconCell, Item> { (cell, indexPath, item) in
            if case let .plantIcon(icon) = item.rowType {
                var config = cell.defaultConfigurtion()
                config.image = icon?.image
                config.tintColor = icon?.color
                cell.contentConfiguration = config
            }
        }
    }

    func createPlantNameCellRegistration() -> UICollectionView.CellRegistration<TextFieldCell, Item> {
        return UICollectionView.CellRegistration<TextFieldCell, Item> { (cell, IndexPath, item) in
            if case let .textField(_, value, placeholder) = item.rowType {
                var config = cell.defaultTextFieldConfiguration()
                config.placeholder = placeholder
                config.value = value
                config.autocapitalizationType = .words
                config.onChange = { [unowned self] newValue in
                    self.editingPlant.name = newValue
                }
                cell.contentConfiguration = config
            }
        }
    }

    func createValueCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var configuration = UIListContentConfiguration.valueCell()

            if case let .listValue(image, text, secondaryText) = item.rowType {
                configuration.image = image
                configuration.text = text
                configuration.secondaryText = secondaryText
            }

            if item.action != nil {
                cell.accessories = [.disclosureIndicator()]
            }
            
            cell.contentConfiguration = configuration
        }
    }

    func createDefaultListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var configuration = cell.defaultContentConfiguration()

            if case let .list(icon, text, secondaryText) = item.rowType {
                configuration.image = icon?.image
                configuration.text = text
                configuration.secondaryText = secondaryText
            }

            if item.action != nil {
                cell.accessories = [.disclosureIndicator()]
            } else if Section.allCases[indexPath.section] == .care {
                cell.accessories = [ .label(text: "Weekly", displayed: .whenNotEditing, options: .init(isHidden: false)), .disclosureIndicator() ]
            }

            cell.contentConfiguration = configuration
        }
    }
    
    func createButtonListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, indexPath, item in
            
        }
    }

    func createSupplementaryHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            var config = UIListContentConfiguration.largeGroupedHeader()
            let section = Section.allCases[indexPath.section]

            config.text = section.description
            
            supplementaryView.contentConfiguration = config
        }
    }

    func createIconBadgeRegistration() -> UICollectionView.SupplementaryRegistration<PlantIconSupplementaryView> {
        return UICollectionView.SupplementaryRegistration<PlantIconSupplementaryView>(elementKind: PlantIconSupplementaryView.badgeElementKind) { supplementaryView, elementKind, indexPath in
            guard let itemIdentifier: Item = self.dataSource.itemIdentifier(for: indexPath) else { return }

            if case .plantIcon(_) = itemIdentifier.rowType {
                supplementaryView.image = UIImage(systemName: "pencil")
                supplementaryView.tapAction = itemIdentifier.action
            }
        }
    }

    func createAddNewReminderFooterRegistration() -> UICollectionView.SupplementaryRegistration<ButtonHeaderFooterView> {
        return UICollectionView.SupplementaryRegistration<ButtonHeaderFooterView>(elementKind: UICollectionView.elementKindSectionFooter) { supplementaryView, elementKind, indexPath in
            let section = Section.allCases[indexPath.section]

            supplementaryView.imageView.image = section.footerImage
            supplementaryView.textLabel.text = section.footerTitle
        }
    }
}

// MARK: - DataSource Configuration
extension PlantEditorControllerController {
     func makeSnapshot(from plant: GHPlant) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        // Header Image
        snapshot.appendItems([
            Item(
                rowType: .plantIcon(plant.icon),
                action: { [unowned self] in
                    let vc = PlantIconPickerController(plant: plant, viewContext: self.viewContext)
                    vc.delegate = self
                    let nav = UINavigationController(rootViewController: vc)
                    self.navigateTo(nav, modal: true)
                }
            )
        ], toSection: .image)
        
        // General Plant Info
        snapshot.appendItems([
            Item(
                rowType: .textField(image: UIImage(systemName: "leaf.fill"), value: plant.name, placeholder: "Plant Name")
            ),
            Item(
                rowType: .listValue(image: nil, text: "Plant Type", secondaryText: plant.type?.commonName ?? "Choose Type"),
                action: { [unowned self] in
                    self.navigateTo(self.plantTypePicker)
                }
            )
        ], toSection: .plantInfo)
        
        // Plant Tasks
        let tasks: [Item] = plant.tasks.compactMap { [unowned self] task in
            Item(
                rowType: .list(icon: task.taskType?.icon, text: task.taskType?.name, secondaryText: task.interval?.intervalText()), action: { [unowned self] in
                    self.showTaskEditor(for: task)
                }
            )
        }
        snapshot.appendItems(tasks, toSection: .care)
        
        let deleteItem = Item(rowType: .button(image: UIImage(systemName: "trash.fill"), text: "Delete Plant", tintColor: UIColor.systemRed))
        snapshot.appendItems([deleteItem], toSection: .actions)
        return snapshot
    }

    internal func configureDataSource() {
        let plantIconRegistration = createPlantIconCellRegistration()
        let plantNameCellRegistration = createPlantNameCellRegistration()
        let valueCellResistration = createValueCellRegistration()
        let defaultRegistration = createDefaultListCellRegistration()
        let buttonCellRegistration = createButtonListCellRegistration()

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            switch item.rowType {
                case .list:
                    return collectionView.dequeueConfiguredReusableCell(using: defaultRegistration, for: indexPath, item: item)
                case .listValue:
                    return collectionView.dequeueConfiguredReusableCell(using: valueCellResistration, for: indexPath, item: item)
                case .plantIcon:
                    return collectionView.dequeueConfiguredReusableCell(using: plantIconRegistration, for: indexPath, item: item)
                case .textField:
                    return collectionView.dequeueConfiguredReusableCell(using: plantNameCellRegistration, for: indexPath, item: item)
                case .button:
                    return collectionView.dequeueConfiguredReusableCell(using: buttonCellRegistration, for: indexPath, item: item)
            }
        }

        let supplementartyHeaderView = createSupplementaryHeaderRegistration()
        let buttonFooterView = createAddNewReminderFooterRegistration()
        let iconBadgeView = createIconBadgeRegistration()
        dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            switch elementKind {
                case UICollectionView.elementKindSectionHeader:
                    return collectionView.dequeueConfiguredReusableSupplementary(using: supplementartyHeaderView, for: indexPath)
                case UICollectionView.elementKindSectionFooter:
                    return collectionView.dequeueConfiguredReusableSupplementary(using: buttonFooterView, for: indexPath)
                case PlantIconSupplementaryView.badgeElementKind:
                    return collectionView.dequeueConfiguredReusableSupplementary(using: iconBadgeView, for: indexPath)
                default:
                    return nil
            }
        }

        // initial data
        let snapshot: NSDiffableDataSourceSnapshot<Section, Item>

        snapshot = makeSnapshot(from: editingPlant)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

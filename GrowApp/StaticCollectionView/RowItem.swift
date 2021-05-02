//
//  RowItem.swift
//  GrowApp
//
//  Created by Ryan Thally on 4/18/21.
//

import UIKit

struct RowItem: Hashable {
    static func == (lhs: RowItem, rhs: RowItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    enum RowType: Hashable {
           // List Cells
           case value1, value2, subtitle

           // Form Cells
           case textField, button, pickerRow

           // Sprout Cells
           case compactCard
           case icon, hero, header, largeHeader
           case statistic
           case todo
           case customView
    }

    typealias TapAction = () -> Void
    typealias ValueChangedAction = (_ sender: Any) -> Void
    typealias Icon = GHIcon

    enum DisplayContext: Int, Hashable {
        case normal, primary, destructive
    }

    // Unique identifier of the row
    var id: UUID
    var rowType: RowType

    // Display Properties
    var text: String?
    var secondaryText: String?
    var tertiaryText: String?
    var image: UIImage?
    var icon: Icon?
    var isOn: Bool
    var tintColor: UIColor?
    var displayContext: DisplayContext?
    var accessories: [UICellAccessory]?

    // Actions
    var tapAction: TapAction?
    var valueChangedAction: ValueChangedAction?

    var customView: UIView?

    var isTappable: Bool {
        return tapAction != nil
    }

    /// Memberwise Initialzier. Not all properties are used in every row type.
    /// - Parameters:
    ///   - id: Unique Identifier of the item
    ///   - rowType: Visual representation of the row
    ///   - text: Primary Text
    ///   - secondaryText: Secondary Text
    ///   - tertiaryText: Tertiary Text
    ///   - image: Image to display
    ///   - icon: Icon to display
    ///   - isOn: Flag to represent the state of a switch with an on/off state
    private init(id: UUID = UUID(), rowType: RowType, text: String? = nil, secondaryText: String? = nil, tertiaryText: String? = nil, image: UIImage? = nil, icon: Icon? = nil, isOn: Bool = false, tintColor: UIColor? = .systemBlue, displayContext: DisplayContext? = nil, accessories: [UICellAccessory]? = nil, tapAction: TapAction? = nil, valueChangedAction: ValueChangedAction? = nil, customView: UIView? = nil) {
        self.id = id
        self.rowType = rowType
        self.text = text
        self.secondaryText = secondaryText
        self.tertiaryText = tertiaryText
        self.image = image
        self.icon = icon
        self.isOn = isOn
        self.tintColor = tintColor
        self.displayContext = displayContext
        self.accessories = accessories
        self.tapAction = tapAction
        self.valueChangedAction = valueChangedAction
        self.customView = customView
    }

    // MARK: - List Cell Factory Methods

    /// Creates a new RowItem for a UICollectionViewListCell
    /// - Parameters:
    ///   - id: Unique identifier for the item
    ///   - text: The primary text
    ///   - secondaryText: The secondary text
    ///   - image: The image to display
    /// - Returns: The configured RowItem
    static func listCell(id: UUID = UUID(), rowType: RowType = .value1, text: String? = nil, secondaryText: String? = nil, image: UIImage? = nil, accessories: [UICellAccessory] = [], tapAction: TapAction? = nil) -> RowItem {
        RowItem(id: id, rowType: rowType, text: text, secondaryText: secondaryText, image: image, accessories: accessories, tapAction: tapAction)
    }

    // MARK: - Form Cell Factory Methods

    /// Creates a new RowItem for a TextFieldCell
    /// - Parameters:
    ///   - id: Uniequ identifier for the item
    ///   - title: The title of the cell
    ///   - placeholder: The placeholder text of the text field
    ///   - initialValue: The initial value of the text field
    ///   - onChange: Closure to perform an action when the text field text changes
    /// - Returns: The configured RowItem
    static func textField(id: UUID = UUID(), title: String? = nil, placeholder: String?, initialValue: String?, onChange: ValueChangedAction?) -> RowItem {
        RowItem(id: id, rowType: .textField, text: title, secondaryText: placeholder, tertiaryText: initialValue, valueChangedAction: onChange)
    }

    static func button(id: UUID = UUID(), context: DisplayContext = .normal, title: String? = nil, image: UIImage? = nil, tintColor: UIColor? = nil, onTap: TapAction?) -> RowItem {
        return RowItem(id: id, rowType: .button, text: title, image: image, tintColor: tintColor, displayContext: context, tapAction: onTap)
    }

    // MARK: - Sprout Cell Factory Methods
    
    /// Creates a new RowItem for an Icon
    /// - Parameters:
    ///   - id: Unique identifier for the item
    ///   - icon: The icon
    /// - Returns: The configured RowItem
    static func icon(id: UUID = UUID(), image: UIImage?, tapAction: TapAction? = nil) -> RowItem {
        RowItem(id: id, rowType: .icon, image: image, tapAction: tapAction)
    }

    static func hero(id: UUID = UUID(), image: UIImage?, title: String?, subtitle: String? = nil) -> RowItem {
        RowItem(id: id, rowType: .hero, text: title, secondaryText: subtitle, image: image)
    }

    /// Creates a new RowItem for a large header
    /// - Parameters:
    ///   - id: Unique identifier for the item
    ///   - title: The title
    ///   - subtitle: The subtitle
    /// - Returns: The configured RowItem
    static func titleHeader(id: UUID = UUID(), title: String?, subtitle: String?) -> RowItem {
        RowItem(id: id, rowType: .header, text: title, secondaryText: subtitle)
    }

    static func largeHeader(id: UUID = UUID(), title: String?, value: String?, image: UIImage?, tintColor: UIColor?) -> RowItem {
        RowItem(id: id, rowType: .largeHeader, text: title, secondaryText: value, image: image, tintColor: tintColor)
    }

    /// Creates a new RowItem for a statistic cell
    /// - Parameters:
    ///   - id: Unique identifier for the item
    ///   - title: The title
    ///   - value: The value
    ///   - unit: The unit
    ///   - icon: The icon
    ///   - tintColor: Primary tint color of the item
    /// - Returns: The configured RowItem
    static func statistic(id: UUID = UUID(), title: String?, value: String?, unit: String? = nil, image: UIImage? = nil, icon: Icon? = nil, tintColor: UIColor? = nil, tapAction: TapAction? = nil) -> RowItem {
        RowItem(id: id, rowType: .statistic, text: title, secondaryText: value, tertiaryText: unit, image: image, icon: icon, tintColor: tintColor, tapAction: tapAction)
    }

    /// Creates a new RowItem for a todo cell
    /// - Parameters:
    ///   - id: Unique identifier for the item
    ///   - title: The title
    ///   - subtitle: The subtitle
    ///   - image: The image
    ///   - icon: The icon
    ///   - taskState: Flag to represent the state of a switch with an on/off state
    ///   - tintColor: Primary tint color of the item
    /// - Returns: The configured RowItem
    static func todo(id: UUID = UUID(), title: String?, subtitle: String?, image: UIImage? = nil, icon: Icon? = nil, taskState: Bool, tintColor: UIColor? = nil, tapAction: TapAction? = nil) -> RowItem {
        RowItem(id: id, rowType: .todo, text: title, secondaryText: subtitle, image: image, icon: icon, isOn: taskState, tintColor: tintColor, tapAction: tapAction)
    }

    static func pickerRow(id: UUID = UUID(), title: String?, subtitle: String? = nil, image: UIImage? = nil, icon: Icon? = nil, isSelected: Bool, tapAction: TapAction? = nil) -> RowItem {
        RowItem(id: id, rowType: .pickerRow, text: title, secondaryText: subtitle, image: image, icon: icon, isOn: isSelected, tapAction: tapAction)
    }

    static func compactCardCell(id: UUID = UUID(), title: String?, value: String?, image: UIImage? = nil, tapAction: TapAction? = nil) -> RowItem {
        RowItem(id: id, rowType: .compactCard, text: title, secondaryText: value, image: image, tapAction: tapAction)
    }

    static func customView(id: UUID = UUID(), customView: UIView) -> RowItem {
         RowItem(id: id, rowType: .customView, customView: customView)
    }
}
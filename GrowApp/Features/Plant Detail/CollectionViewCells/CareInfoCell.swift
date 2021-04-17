//
//  CareInfoCell.swift
//  GrowApp
//
//  Created by Ryan Thally on 3/4/21.
//

import UIKit

class CareInfoCell: UICollectionViewCell {
    lazy var careTypeIconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .headline)
        
        let contentHuggingPriority = view.contentHuggingPriority(for: .horizontal) + 1
        view.setContentHuggingPriority(contentHuggingPriority, for: .horizontal)
        return view
    }()
    
    lazy var careTypeLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        return view
    }()
    
    lazy var nextCareLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        return view
    }()
    
    lazy var lastCareLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHiearchy()
        backgroundColor = .quaternarySystemFill
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHiearchy() {
        let headerStack = UIStackView(arrangedSubviews: [careTypeIconView, careTypeLabel])
        headerStack.axis = .horizontal
        headerStack.distribution = .fill
        headerStack.alignment = .lastBaseline
        headerStack.spacing = 8
        
        let contentStack = UIStackView(arrangedSubviews: [headerStack, nextCareLabel, lastCareLabel])
        contentStack.axis = .vertical
        contentStack.distribution = .fill
        contentStack.alignment = .fill
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentStack)
        contentStack.safePinToLayoutMarginsOf(contentView)
    }
}
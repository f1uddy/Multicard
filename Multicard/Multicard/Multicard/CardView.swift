//
//  CardView.swift
//  Multicard
//
//  Created by Кирилл Верхоутров on 11/10/2019.
//  Copyright © 2019 Кирилл Верхоутров. All rights reserved.
//

import UIKit

typealias ColorSate = (title: UIColor, subtitle: UIColor, back: UIColor)

class CardView: UIView {
    
    enum State {
        case selected
        case deselected
        case unavailable
        case _default
        
        static var selectedStateColors: ColorSate?
        static var deselectedStateColors: ColorSate?
        static var unavailibleStateColors: ColorSate?
        static var defaultStateColors: ColorSate?
        
        func color() -> ColorSate? {
            switch self {
            case .selected:
                return State.selectedStateColors
            case .deselected:
                return State.deselectedStateColors
            case .unavailable:
                return State.unavailibleStateColors
            case ._default:
                return State.defaultStateColors
            }
        }
    }
    
    //MARK: Public
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    var state: State = ._default {
        didSet {
            reloadView()
        }
    }
    
    var tap: UILongPressGestureRecognizer? {
        didSet {
            if let gestures = self.gestureRecognizers {
                for g in gestures {
                    removeGestureRecognizer(g)
                }
            }
            if let t = tap {
                addGestureRecognizer(t)
            }
            tap?.isEnabled = state != .unavailable
        }
    }
    
    public func reloadView() {
        titleLabel.textColor = state.color()?.title
        subTitleLabel.textColor = state.color()?.subtitle
        backgroundColor = state.color()?.back
        tap?.isEnabled = state != .unavailable
    }
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //MARK: Private
    private func setupView(){
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        reloadView()
    }
}


//
//  MultiCardView.swift
//  Multicard
//
//  Created by Кирилл Верхоутров on 11/10/2019.
//  Copyright © 2019 Кирилл Верхоутров. All rights reserved.
//

import Foundation
import UIKit

public protocol CardViewDelegate {
    // Called when the user taps the cardview
    func didSelectItem(atIndex index: Int)
}

class MultiCardView: UIView {
    
    //MARK: - IBInpectalbe
    @IBInspectable var maxFontSize:CGFloat = 13.0
    @IBInspectable var maxSubTitleFontSize:CGFloat = 10.0
    @IBInspectable var titlePadding:CGFloat = 5.0
    @IBInspectable var subTitlePadding:CGFloat = 5.0
    @IBInspectable var cardViewRadius:CGFloat = 8.0
    @IBInspectable var itemSpace:CGFloat = 15
    //Color property
    @IBInspectable var deselectedBackgroundColor: UIColor = UIColor.gray {
        didSet {
            updateColors()
        }
    }
    @IBInspectable var deselectedTitleColor: UIColor = UIColor.gray {
        didSet {
            updateColors()
        }
    }
    @IBInspectable var deselectedSubtitleColor: UIColor = UIColor.gray {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var selectedBackgroundColor: UIColor = UIColor.red {
        didSet {
            updateColors()
        }
    }
    @IBInspectable var selectedTitleColor: UIColor = UIColor.red {
        didSet {
            updateColors()
        }
    }
    @IBInspectable var selectedSubtitleColor: UIColor = UIColor.gray {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var unavailibleBackgroundColor: UIColor = UIColor.gray {
        didSet {
            updateColors()
        }
    }
    @IBInspectable var unavailibleTitleColor: UIColor = UIColor.gray {
        didSet {
            updateColors()
        }
    }
    @IBInspectable var unavailibleSubtitleColor: UIColor = UIColor.gray {
        didSet {
            updateColors()
        }
    }
    @IBInspectable var defaultBackgroundColor: UIColor = UIColor.gray {
        didSet {
            updateColors()
        }
    }
    @IBInspectable var defaultTitleColor: UIColor = UIColor.gray {
        didSet {
            updateColors()
        }
    }
    @IBInspectable var defaultSubtitleColor: UIColor = UIColor.gray {
        didSet {
            updateColors()
        }
    }
    
    
    public func changeAllStates(state: CardView.State) {
        for i in 0..<cardsModel.count {
            states[i] = state
        }
    }
    
    public func chageState(forIndex index: Int, state: CardView.State) {
        if index >= cards.count || index < 0 {
            assertionFailure("Unavalible index")
            return
        }
        states[index] = state
        updateStates()
    }
    
    var cardsModel = [CardModelDataSource]() {
        didSet {
            updateCardsModelData()
            updateColors()
        }
    }
    
    func updateCardsModelData() {
        for (i, v) in cards.enumerated() {
            v.titleLabel.text = cardsModel[i].title
            if v.subTitleLabel.text != cardsModel[i].subTitle {
                v.subTitleLabel.isHidden = false
                v.subTitleLabel.text = cardsModel[i].subTitle
                if v.state == .deselected, states[i] == .deselected {
                    reculcNewFontSizeByWidth()
                    animateView(view: cards[i].subTitleLabel)
                }
            }
        }
    }
    
    var delegate: CardViewDelegate?
    
    //MARK: UIView lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        reculcNewFontSizeByWidth()
    }
    
    //MARK: Private
    private var cards = [CardView]()
    private var states = [Int: CardView.State]() {
        didSet {
            updateStates()
        }
    }
    private func updateStates() {
        for (i, v) in cards.enumerated() {
            v.state = states[i] ?? ._default
        }
    }
    
    private func animateView(view: UIView) {
        view.fadeOut()
        view.fadeIn()
    }
    
    private func updateColors() {
        CardView.State.selectedStateColors = (selectedTitleColor, selectedSubtitleColor, selectedBackgroundColor)
        CardView.State.deselectedStateColors = (deselectedTitleColor, deselectedSubtitleColor, deselectedBackgroundColor)
        CardView.State.unavailibleStateColors = (unavailibleTitleColor, unavailibleSubtitleColor, unavailibleBackgroundColor)
        CardView.State.defaultStateColors = (defaultTitleColor, defaultSubtitleColor, defaultBackgroundColor)
        for v in cards {
            v.reloadView()
        }
    }
    
    // Generation cards
    func setupCards() {
        var prevCardView: CardView?
        var prevDummyyView: UIView?
        
        //Generate CardView
        for i in 0..<cardsModel.count {
            let cardView = CardView(frame: .zero)
            cardView.titleLabel.text = cardsModel[i].title
            cardView.subTitleLabel.text = cardsModel[i].subTitle
            
            cardView.layer.cornerRadius = cardViewRadius
            cardView.tag = i
            
            cardView.titleLabel.leadingAnchor.constraint(equalTo: cardView.stackView.leadingAnchor, constant: titlePadding).isActive = true
            cardView.titleLabel.trailingAnchor.constraint(equalTo: cardView.stackView.trailingAnchor, constant: -titlePadding).isActive = true
            cardView.subTitleLabel.leadingAnchor.constraint(equalTo: cardView.stackView.leadingAnchor, constant: subTitlePadding).isActive = true
            cardView.subTitleLabel.trailingAnchor.constraint(equalTo: cardView.stackView.trailingAnchor, constant: -subTitlePadding).isActive = true
            cardView.tap = tapGesture()
            
            cardView.subTitleLabel.isHidden = true
            
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardView.state = states[i] ?? .unavailable
            cards.append(cardView)
            
            let leftDummyView = UIView(frame: .zero)
            leftDummyView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(leftDummyView)
            leftDummyView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            leftDummyView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            addSubview(cardView)
            
            if let pDV = prevDummyyView {
                leftDummyView.widthAnchor.constraint(equalTo: pDV.widthAnchor, multiplier: 1).isActive = true
            } else {
                leftDummyView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            }
            
            if let p = prevCardView {
                p.trailingAnchor.constraint(equalTo: leftDummyView.leadingAnchor).isActive = true
                cardView.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 1).isActive = true
                cardView.leadingAnchor.constraint(equalTo: p.trailingAnchor, constant: itemSpace).isActive = true
            } else {
                cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: itemSpace).isActive = true
            }
            
            cardView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            leftDummyView.trailingAnchor.constraint(equalTo: cardView.leadingAnchor).isActive = true
            
            if i == cardsModel.count - 1 {
                let rightDummyView = UIView(frame: .zero)
                rightDummyView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(rightDummyView)
                rightDummyView.leadingAnchor.constraint(equalTo: cardView.trailingAnchor).isActive = true
                rightDummyView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                rightDummyView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                rightDummyView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                leftDummyView.widthAnchor.constraint(equalTo: rightDummyView.widthAnchor, multiplier: 1).isActive = true
                trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: itemSpace).isActive = true
            } else {
                prevCardView = cardView
                prevDummyyView = leftDummyView
            }
            
            
        }
    }
    
    private func tapGesture() -> UILongPressGestureRecognizer {
        var myRecognizer = UILongPressGestureRecognizer()
        myRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAction(gesture:)))
        myRecognizer.minimumPressDuration = 0
        return myRecognizer
    }
    
    @objc func addAction(gesture : UILongPressGestureRecognizer) {
        guard let v = gesture.view as? CardView else {
            return
        }
        if gesture.state == .began {
            states[v.tag] = .selected
            updateStates()
        } else if gesture.state == .ended {
            delegate?.didSelectItem(atIndex: v.tag)
            states[v.tag] = .deselected
            updateStates()
        }
    }
    
    private func reculcNewFontSizeByWidth(){
        let newFontSize = maxFontSize
        let newSubTitleFontSize = maxSubTitleFontSize
        
        let titles = cardsModel.map { $0.title }
        let subTitles = cardsModel.map { $0.subTitle }
        
        let titleSize = getNewFontSize(defaultValue: newFontSize, forStrings: titles, padding: titlePadding)
        let subTitleSize = getNewFontSize(defaultValue: newSubTitleFontSize, forStrings: subTitles, padding: subTitlePadding)
        
        for i in 0..<cardsModel.count{
            let cardLabel = cards[i]
            cardLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: titleSize)
            cardLabel.subTitleLabel.font = UIFont.systemFont(ofSize: subTitleSize)
        }
    }
    
    func getNewFontSize(defaultValue: CGFloat, forStrings strings: [String?], padding: CGFloat) -> CGFloat{
        var titleSize: CGSize!
        var maxStringSize:CGFloat = 0.0
        var maxString: String = ""
        var newFontSize = defaultValue
        let cardWidth = (self.frame.size.width - (itemSpace * (CGFloat(cardsModel.count) + 1))) / CGFloat(cardsModel.count)
        let cardWidthWithPadding = cardWidth - (padding * 2)
        
        for string in strings {
            if let s = string {
                titleSize = s.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(maxFontSize))])
                if maxStringSize < titleSize.width{
                    maxStringSize = titleSize.width
                    maxString = s
                }
            }
        }
        
        while maxStringSize > cardWidthWithPadding {
            newFontSize = newFontSize - 1
            maxStringSize = maxString.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(newFontSize))]).width
        }
        return newFontSize
    }
}

fileprivate extension UIView {
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}

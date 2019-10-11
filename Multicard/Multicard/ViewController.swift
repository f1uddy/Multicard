//
//  ViewController.swift
//  Multicard
//
//  Created by Кирилл Верхоутров on 11/10/2019.
//  Copyright © 2019 Кирилл Верхоутров. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet fileprivate weak var multiCardView: MultiCardView!

    //MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        multiCardView.cardsModel = [CardModelDataSource(title: "Test", subTitle: "test"), CardModelDataSource(title: "Test", subTitle: "test"), CardModelDataSource(title: "Test", subTitle: "test")]
        multiCardView.setupCards()
        multiCardView.changeAllStates(state: ._default)
        multiCardView.delegate = self
    }


}

//MARK: CardViewDelegate
extension ViewController: CardViewDelegate {
    func didSelectItem(atIndex index: Int) {
        print(index)
    }
}

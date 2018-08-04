//
//  ExtensionCollectionView.swift
//  
//
//  Created by zabih atashbarg on 4/22/18.
//  Copyright © 2018 Zabih. All rights reserved.
//

import UIKit

extension UICollectionView {

    func getHeightOfContent() -> CGFloat {
        reloadData()
        return collectionViewLayout.collectionViewContentSize.height
    }
    
}





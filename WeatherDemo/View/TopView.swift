//
//  TopView.swift
//  WeatherDemo
//
//  Created by Adem Özsayın on 26.06.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit

class TopView : UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    var selectedRow = 0
    let h :CGFloat = 0.66 // for collectionview height to be 2/3 of the view
    let y :CGFloat = 0.33 // collectionview y position

    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    let weatherCell = "cell"
        
    var city:String? {
        didSet {
            DispatchQueue.main.async {
                self.cityLabel.text = self.city?.uppercased()
            }
        }
    }
    lazy var cityLabel: SPLabel = {
       let l = SPLabel()
        l.frame = CGRect(x: 10, y: 80, width: 200, height: 40)
        l.font = UIFont.system(weight: .bold, size: 18)
        return l
    }()
    
    var date:String? {
        didSet {
            DispatchQueue.main.async {
                self.dateLabel.text = self.date
            }
        }
    }
    
    lazy var degreeLabel: SPLabel = {
       let l = SPLabel()
        l.frame = CGRect(x: self.frame.width - 250, y: 70, width: 240, height: self.frame.height * y - 70)
        l.font = UIFont.system(weight: .bold, size: 66)
        l.textAlignment = .right
        return l
    }()
    
    var degree:String? {
        didSet {
            DispatchQueue.main.async {
                self.degreeLabel.text = self.degree
            }
        }
    }
    
    lazy var dateLabel: SPLabel = {
        let l = SPLabel()
        l.frame = CGRect(x: 10, y: 100, width: 200, height: 40)
        l.font = UIFont.system(weight: .regular, size: 14)
        return l
      }()

    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
      

        let cv = UICollectionView(frame: CGRect(x: 0,
                                                y: self.frame.height * y,
                                                width: self.frame.width,
                                                height: self.frame.height * h),
                                  collectionViewLayout: layout)
        cv.register(WeatherCell.self, forCellWithReuseIdentifier: weatherCell)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        
        if let layout = cv.collectionViewLayout as? UICollectionViewFlowLayout {
             layout.minimumLineSpacing = 10
             layout.minimumInteritemSpacing = 10
             layout.sectionInset = sectionInsets
             layout.scrollDirection = .horizontal
         }
        cv.isPagingEnabled = false
        cv.toggleThemed()
        return cv
    }()
    
    var itemSize = CGSize(width: 0, height: 0)

    
    var list:[List] = [] {
        didSet {
            DispatchQueue.main.async {
                self.dateLabel.text = self.list[0].getMonthWithName()
                self.collectionView.reloadData()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SPNativeColors.customGray
        setup()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup()

    }
    
    private func setup(){
     
        self.addSubview(cityLabel)//
        self.addSubview(dateLabel)//
        self.addSubview(degreeLabel)//dateLabel
        self.addSubview(collectionView)
        toggleTheme()
 
    }

    
    

    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherCell, for: indexPath) as! WeatherCell
        let weatherList = self.list[indexPath.row]
        var isSelected: Bool = false
       
        if selectedRow == indexPath.row {
            isSelected = true
            cell.imageView.frame = CGRect(x: (cell.frame.width/2) - 40 , y: (cell.frame.height / 2) - 40, width: 80, height: 80)
            cell.degreeLabel.frame = CGRect(x: (cell.frame.width/2) - 40 , y: cell.frame.height - 50, width: 80, height: 20)
            cell.hourView.frame = CGRect(x: (cell.frame.width/2) - 40 , y: 20, width: 80, height: 40)
            cell.hourLbael.frame = CGRect(x: 10, y: 5, width: cell.hourView.frame.width - 20, height: 30)
        } else {
           isSelected = false
            cell.imageView.frame = CGRect(x: (cell.frame.width/2) - 20 , y: (cell.frame.height / 2) - 20, width: 40, height: 40)
            cell.degreeLabel.frame = CGRect(x: (cell.frame.width/2) - 40 , y: cell.frame.height - 60, width: 80, height: 20)
            cell.hourView.frame = CGRect(x: (cell.frame.width/2) - 35 , y: 20, width: 70, height: 40)
            cell.hourLbael.frame = CGRect(x: 7.5, y: 5, width: cell.hourView.frame.width - 20, height: 30)
        }
        
        cell.toggleThemed(isSelected: isSelected)
        
        if selectedRow == indexPath.row {
            cell.imageView.image = weatherList.weather[0].getImage(color: cell.iconColor)
        } else {
            cell.imageView.image = weatherList.weather[0].getImage(color: cell.iconColor)
        }
        
        cell.setData(data: weatherList)

        return cell

    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if selectedRow == indexPath.row {
            //selectedRow = -1
            return
        } else {
            selectedRow = indexPath.row
        }
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.row == selectedRow {
            return CGSize(width: (self.frame.width / 2) - 50, height: 250)//CGSize(width: 200, height: collectionView.frame.height - 50)
        } else {
            return CGSize(width: (self.frame.width / 2) - 70, height: 200)
        }
    }
    

//
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    //MARK: flowlayout
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
       
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return sectionInsets.left
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        //Where elements_count is the count of all your items in that
        //Collection view...
        let cellCount = CGFloat(list.count)

        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing

            //20.00 was just extra spacing I wanted to add to my cell.
            let totalCellWidth = cellWidth*cellCount + 20.00 * (cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.

                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
            }
        }
        return UIEdgeInsets.zero
    }
    
    
    

}


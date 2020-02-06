//
//  PrimaryColorViewController.swift
//  PrimaryColorFusion
//
//  Created by 辜鹏 on 2019/10/9.
//  Copyright © 2019 PengGu. All rights reserved.
//

import UIKit

class PrimaryColorViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var pageControl: UIPageControl!
        
    
    var images:[String] = ["rgb","cmyk"]
  
    var titles = ["RGB","CMYK"]
    
    var contentdataSource = ["""
Generally, the color used when projecting with a light source is a primary color system belonging to the "overlay type". The system consists of three primary colors, red, green and blue, also known as "three primary colors." Other colors can be produced using these three primary colors. For example, red and green produce yellow or orange, green and blue produce cyan, and blue and red produce purple or magenta.
""","""
The subtractive primary color is also known as the subtractive primary color. Generally, the color used when coloring with a reflective light source or pigment is a "subtractive" primary color system. The system contains three primary colors of yellow, cyan, and magenta, For example, a mixture of yellow and cyan can produce green, a mixture of yellow and magenta can produce red, and a mixture of magenta and cyan can produce blue.
"""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        setupUI()
        
    }
    
    
    
      func setupUI() {
          
          
          collectionView.dataSource = self
          collectionView.delegate = self
          
          collectionView.register(UINib(nibName:"PrimaryColorCell", bundle: nil), forCellWithReuseIdentifier: "PrimaryColorCell")
          
          let layout = UICollectionViewFlowLayout()
        
          layout.itemSize = CGSize(width: contentWidth, height: contentHeight )
          
          
          
          layout.minimumInteritemSpacing = 0
          layout.minimumLineSpacing = 0
          
          
          layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
          
          layout.scrollDirection = .horizontal
          
          collectionView.collectionViewLayout = layout
          
          
      }
      
    
    



}

extension PrimaryColorViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:PrimaryColorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrimaryColorCell", for: indexPath) as! PrimaryColorCell
        cell.titleLb.text = titles[indexPath.row]
        cell.contentLb.text = contentdataSource[indexPath.row]
        cell.imgView.image = UIImage(named: images[indexPath.row])
        return cell
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        
        pageControl.currentPage = Int(pageNumber)
        
    }
    
    
    
}

//
//  GameSecViewController.swift
//  PrimaryColorFusion
//
//  Created by 辜鹏 on 2019/10/12.
//  Copyright © 2019 PengGu. All rights reserved.
//

import UIKit
import AVFoundation

class GameSecViewController: UIViewController {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var horizontalView: UIView!
    @IBOutlet weak var verticalView: UIView!
    
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var left: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    
    var audioPlayer:AVAudioPlayer?
    var audioPlayer2:AVAudioPlayer?
    
    
    
    @IBOutlet weak var scoreLb: UILabel!
    
    var ballIndexs:[Int]?
    var starIndex:[Int]?
    
    var index = 1
    var timer:Timer?
    var timer2:Timer?
    
    
    
    var  originStarColor = ["star_1","star_2","star_3"]
    
    //    var  originStarSecColor = ["star_red","star_green","star_blue"]
    
    var topDistance:CGFloat?
    var randomKey:String?
    
    
    /// "round_2":"star_3" yellow
    /// "round_3":"star_2"  酒红
    /// "round_1":"round_blue" 淡蓝
    var colorsDict = ["round_1":"star_1","round_2":"star_3","round_3":"star_2"]
    var colorsDict2 = ["star_1":"round_1","star_3":"round_2","star_2":"round_3"]
    
    let colors = ["star_red": UIColor.red,"star_green":UIColor.green,"star_blue":UIColor.blue]
    
    
    var workItem:DispatchWorkItem?
    
    @IBOutlet weak var myBtn: UIImageView!
    
    var tapFlag = false
    
    var score = 0
    var myscore:[Int] = [Int]()
    
    
    var time : DispatchTime = .now() + .seconds(8)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        scoreLb.text = String(score)
        
        if index == 1  {
            show()
            index = 0
        }
        
        
        initColors()
        checkLaser()
        play()
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshback), name: Notification.Name.init(rawValue: "refreshback"), object: nil)
        
        
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        
        myBtn.addGestureRecognizer(longGesture)
        
        var flag = UserDefaults.standard.bool(forKey: "flag")
        
        if flag == true {
            
            playbgmusic()
            
        }
        
        
        
        
    }
    
    

    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        print(" ........")
        DispatchQueue.main.async {
            self.workItem!.cancel()
        }
        timer!.invalidate()
        audioPlayer?.pause()
        audioPlayer2?.pause()
        
        
    }
    
    func playbgmusic()  {
        
        var path = Bundle.main.path(forResource: "bgmusic", ofType: "mp3")
        var pathURL = NSURL(fileURLWithPath: path!)
        
        do {
            audioPlayer2 = try AVAudioPlayer(contentsOf: pathURL as URL)
        } catch {
            audioPlayer2 = nil
        }
        audioPlayer2?.prepareToPlay()
        audioPlayer2?.numberOfLoops = -1
        
        audioPlayer2?.play()
        
    }
    
    
    func music()  {
        
        let path = Bundle.main.path(forResource: "correct", ofType: "mp3")
        let pathURL = NSURL(fileURLWithPath: path!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pathURL as URL)
        } catch {
            audioPlayer = nil
        }
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        
    }
    
    
        @objc func longTap(sender : UIGestureRecognizer){
            print("Long tap")
            if sender.state == .ended {
                print("UIGestureRecognizerStateEnded")
                tapFlag = false
            }
            else if sender.state == .began {
                print("UIGestureRecognizerStateBegan.")
                tapFlag = true
    
            }
        }
    
    @objc func refreshback()  {
        
        show()
        initColors()
        collectionView.reloadData()
        self.top.constant = -10
        self.left.constant = -10
        score = 0
        scoreLb.text = String(0)
        checkLaser()
        play()

        
        
    }
    
    
    
    func play()  {
        
        
        self.top.constant = -10
        self.left.constant = -10
        
        horizontalView.isHidden = true
        verticalView.isHidden = true
        alertView.isHidden = true
        
       
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                 
                 self.alertView.isHidden = false
                 
             }
             
             
             DispatchQueue.main.asyncAfter(deadline:  .now() + 3.1) {
                 
                 self.alertView.isHidden = true
                 self.horizontalView.isHidden = false
                 self.verticalView.isHidden = false
                 
             }
             
             workItem = DispatchWorkItem {
                 
                 DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
                     
                     let duration:TimeInterval = 30
                     UIView.animate(withDuration: duration, animations: {
                         
                         
                         self.top.constant = gameHeight
                         self.left.constant = screenWidth
                         
                         self.view.layoutIfNeeded()
                     }) { (Bool) in
                         
                     }
                     
                 }
                 
             }
             
             DispatchQueue.global().async(execute: workItem!)
             
    }
    
    func checkLaser(){
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(checkGame), userInfo: nil, repeats: true)

        
    }
    

    
    @objc func checkGame(){
        
        if horizontalView == nil  || verticalView == nil {
            return
        }
        
        let indexPath = IndexPath(row: starIndex![0], section: 0 )
        let cell = self.collectionView.cellForItem(at: indexPath) as? GameCell
        if cell == nil  {return}
        let realCenter = collectionView.convert(cell!.frame, to: collectionView.superview)
        
        let f1 = horizontalView.layer.presentation()?.frame
        let f2 = verticalView.layer.presentation()?.frame
        
        
        // 发生碰撞
        if (f1?.intersects(realCenter))! || (f2?.intersects(realCenter))! {
            
            
            
            
            horizontalView.isHidden = true
            verticalView.isHidden = true
            alertView.isHidden = true


            
            
            
            
            //获取当前 view 的背景颜色 和 star的图片颜色 做比较
            //获取当前图片的颜色
            //颜色相同
            if originStarColor[0] == randomKey {
                
                score = score + 100
                scoreLb.text = String(score)
                
                myscore.append(score)
                UserDefaults.standard.set(myscore, forKey: "score2")
                self.workItem!.cancel()
                refreshGame()
                
                
            }else {
                
                print("game over ...")
                score = score + 0
                scoreLb.text = String(score)
                
                
                let failureVc:GameOverViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameOverViewController") as! GameOverViewController
                
                myscore.append(score)
                failureVc.passedScore = String(score)
                UserDefaults.standard.set(myscore, forKey: "score2")
                
                navigationController?.pushViewController(failureVc, animated: true)
                
                
                
            }
            
            
            
            
            
            
            return
        }
    }
    
    
    func refreshGame()  {
        
        show()
        initColors()
        collectionView.reloadData()
        play()
        
    }
    
    
    // 生成警告条颜色
    func initColors()  {
        
        let randomIndex = Int.random(in: 0...2)
        randomKey = Array(colors.keys)[randomIndex]
        horizontalView.backgroundColor = colors[randomKey!]
        verticalView.backgroundColor = colors[randomKey!]
            
        
    }
    
    
    func show()  {
        
        
        var indexs:[Int] = [Int]()
        
        for index in 0...44 {
            indexs.append(index)
        }
        
        indexs.remove(at: [0,1,2,3,4,5,10,15,20,25,30,35,40])
        
        indexs.shuffle()
        
        
        ballIndexs = [indexs[0],indexs[1],indexs[2]]
        starIndex  = [indexs[3]]
        
    }
    
    
    func setupUI() {
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView?.contentInsetAdjustmentBehavior = .always
        
        collectionView.register(UINib(nibName:"GameCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
        
        let layout = UICollectionViewFlowLayout()
        
        
        let height  = gameHeight / 9
        let width = screenWidth / 5
        
        
        layout.itemSize = CGSize(width: width, height: height )
        layout.sectionInsetReference = .fromContentInset
        
        
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = layout
        
        
        
        
    }
    
    
    
    @IBAction func upAction(_ sender: Any) {
           
           // 第一行
           guard starIndex![0] > 4 else { return }
           
           if tapFlag == true {
               
               starIndex![0] =  starIndex![0] - 10
               guard starIndex![0] > 4 else { return }
               
               
               
           }
           
           
           starIndex![0] =  starIndex![0] - 5
           
           
           // red ball
           if starIndex![0] == ballIndexs![0] {
               starIndex![0] = starIndex![0] + 5
               if tapFlag == true {
                   starIndex![0] = starIndex![0] + 5
                   return
               }

               redBall()
               
               
           }
           
           // green ball
           if starIndex![0] == ballIndexs![1] {

               starIndex![0] = starIndex![0] + 5
               if tapFlag == true {
                   starIndex![0] = starIndex![0] + 5
                   return
               }
               
               greenBall()
               
               
               
               return
               
           }
           
           // blue ball
           if starIndex![0] == ballIndexs![2] {

               starIndex![0] = starIndex![0] + 5
               if tapFlag == true {
                   starIndex![0] = starIndex![0] + 5
                   return
               }
               
               blueBall()
               
               
               
               return
               
           }
           
           
           
           
           collectionView.reloadData()
           
       }
       
       
       @IBAction func leftAction(_ sender: Any) {
           // 左边
           guard starIndex![0] > 0 else { return }
           
           if tapFlag == true {
               
               starIndex![0] =  starIndex![0] - 1
               guard starIndex![0] > 0 else { return }
               
               
               
           }
           
           starIndex![0] =  starIndex![0] - 1
           
           if starIndex![0] == ballIndexs![0] {
               
               starIndex![0] = starIndex![0] + 1
               if tapFlag == true {
                   starIndex![0] = starIndex![0] + 1
                   return
               }

               redBall()
               return
               
           }
           if starIndex![0] == ballIndexs![1] {
               starIndex![0] = starIndex![0] + 1
               if tapFlag == true {
                   starIndex![0] = starIndex![0] + 1
                   return
               }
               greenBall()
               return
               
           }
           if starIndex![0] == ballIndexs![2] {
               starIndex![0] = starIndex![0] + 1
               if tapFlag == true {
                   starIndex![0] = starIndex![0] + 1
                   return
               }
               blueBall()
               return
               
           }
           collectionView.reloadData()
           
           
       }
       
       @IBAction func downAction(_ sender: Any) {
           
           // 最后一行
           guard starIndex![0] < 40 else { return }
           
           if tapFlag == true {
               
               starIndex![0] =  starIndex![0] + 10
               guard starIndex![0] < 40 else { return }
           }
           
           starIndex![0] =  starIndex![0] + 5
           
           if starIndex![0] == ballIndexs![0] {

               starIndex![0] = starIndex![0] - 5
               if tapFlag == true {
                   starIndex![0] = starIndex![0] - 5
                   return
               }
               redBall()
               return
               
           }
           if starIndex![0] == ballIndexs![1] {
               starIndex![0] = starIndex![0] - 5
               if tapFlag == true {
                   starIndex![0] = starIndex![0] - 5
                   return
               }
               greenBall()
               return
               
           }
           if starIndex![0] == ballIndexs![2] {
               starIndex![0] = starIndex![0] - 5
               if tapFlag == true {
                   starIndex![0] = starIndex![0] - 5
                   return
               }
               blueBall()
               return
               
           }
           collectionView.reloadData()
           
           
       }
       
       @IBAction func rightAction(_ sender: Any) {
           
           guard starIndex![0] < 44 else { return }
           
           if tapFlag == true {
               
               starIndex![0] =  starIndex![0] + 1
               guard starIndex![0] < 44 else { return }
               
               
               
           }
           
           starIndex![0] =  starIndex![0] + 1
           
           if starIndex![0] == ballIndexs![0] {
               starIndex![0] = starIndex![0] - 1
               if tapFlag == true {
                   starIndex![0] = starIndex![0] - 1
                   return
               }
               redBall()
               return
               
           }
           if starIndex![0] == ballIndexs![1] {

               starIndex![0] = starIndex![0] - 1
               if tapFlag == true {
                   starIndex![0] = starIndex![0] - 1
                   return
               }
               greenBall()
               return
               
           }
           if starIndex![0] == ballIndexs![2] {
               starIndex![0] = starIndex![0] - 1
               if tapFlag == true {
                   starIndex![0] = starIndex![0] - 1
                   return
               }
               blueBall()
               return
               
           }
           collectionView.reloadData()
           
           
       }
    
    func redBall()  {
        
        var flag = UserDefaults.standard.bool(forKey: "flag")
        
        if flag == true {
            music()
        }
        /// "round_2":"star_3" yellow
        /// "round_3":"star_2"  酒红
        /// "round_1":"star_1" 淡蓝
        switch originStarColor[0] {
            
        case "star_1":
            
            let indexPath = IndexPath(row: starIndex![0], section: 0 )
            let cell = collectionView.cellForItem(at: indexPath) as! GameCell
            cell.picBtn.setImage(UIImage(named: "star_blue"), for: .normal)
            originStarColor[0] = "star_blue"
        case "star_3":
            
            let indexPath = IndexPath(row: starIndex![0], section: 0 )
            let cell = collectionView.cellForItem(at: indexPath) as! GameCell
            cell.picBtn.setImage(UIImage(named: "star_red"), for: .normal)
            originStarColor[0] = "star_red"
            
        case "star_red","star_green","star_blue":
            
            let indexPath = IndexPath(row: starIndex![0], section: 0 )
            let cell = collectionView.cellForItem(at: indexPath) as! GameCell
            cell.picBtn.setImage(UIImage(named: "star_2"), for: .normal)
            originStarColor[0] = "star_2"
            
        default:
            print("default ... ")
        }
        
        return
    }
    
    
    /// "round_2":"star_3" yellow
    /// "round_3":"star_2"  酒红
    /// "round_1":"star_1" 淡蓝
    
    func greenBall() {
        var flag = UserDefaults.standard.bool(forKey: "flag")
        
        if flag == true {
            music()
        }
        
        switch originStarColor[0] {
            
        case "star_1":
            
            let indexPath = IndexPath(row: starIndex![0], section: 0 )
            let cell = collectionView.cellForItem(at: indexPath) as! GameCell
            cell.picBtn.setImage(UIImage(named: "star_green"), for: .normal)
            originStarColor[0] = "star_green"
            
            
        case "star_2":
            
            let indexPath = IndexPath(row: starIndex![0], section: 0 )
            let cell = collectionView.cellForItem(at: indexPath) as! GameCell
            cell.picBtn.setImage(UIImage(named: "star_red"), for: .normal)
            originStarColor[0] = "star_red"
            
        case "star_red","star_green","star_blue":
            
            let indexPath = IndexPath(row: starIndex![0], section: 0 )
            let cell = collectionView.cellForItem(at: indexPath) as! GameCell
            cell.picBtn.setImage(UIImage(named: "star_3"), for: .normal)
            originStarColor[0] = "star_3"
            
            
        default:
            print("default ... ")
        }
    }
    
    
    
    /// "round_2":"star_3" yellow
    /// "round_3":"star_2"  酒红
    /// "round_1":"star_1" 淡蓝
    
    func blueBall() {
        
        var flag = UserDefaults.standard.bool(forKey: "flag")
        
        if flag == true {
            music()
        }
        
        switch originStarColor[0] {
            
        case "star_2":
            
            let indexPath = IndexPath(row: starIndex![0], section: 0 )
            let cell = collectionView.cellForItem(at: indexPath) as! GameCell
            cell.picBtn.setImage(UIImage(named: "star_blue"), for: .normal)
            originStarColor[0] = "star_blue"
            
        case "star_3":
            
            let indexPath = IndexPath(row: starIndex![0], section: 0 )
            let cell = collectionView.cellForItem(at: indexPath) as! GameCell
            cell.picBtn.setImage(UIImage(named: "star_red"), for: .normal)
            originStarColor[0] = "star_red"
            
            
            
        case "star_red","star_green","star_blue":
            
            let indexPath = IndexPath(row: starIndex![0], section: 0 )
            let cell = collectionView.cellForItem(at: indexPath) as! GameCell
            cell.picBtn.setImage(UIImage(named: "star_1"), for: .normal)
            originStarColor[0] = "star_1"
            
            
        default:
            print("default ... ")
        }
        
    }
    
    
    
}
extension GameSecViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 45
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:GameCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        
        
        switch indexPath.row  {
        case ballIndexs![0]:
            cell.picBtn.setImage(UIImage(named: "round_3"), for: .normal)
        case ballIndexs![1]:
            cell.picBtn.setImage(UIImage(named: "round_2"), for: .normal)
        case ballIndexs![2]:
            cell.picBtn.setImage(UIImage(named: "round_1"), for: .normal)
            
            
        case starIndex![0]:
            cell.picBtn.setImage(UIImage(named: originStarColor[0]), for: .normal)
            
        default:
            cell.picBtn.setImage(UIImage(), for: .normal)
        }
        
        
        return cell
        
    }
    
    
    
}

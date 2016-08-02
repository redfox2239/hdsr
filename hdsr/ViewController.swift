//
//  ViewController.swift
//  hdsr
//
//  Created by 原田　礼朗 on 2016/07/23.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

class PointCell: UICollectionViewCell {
    @IBOutlet weak var pointLabel: UILabel!
}

class ButtonCell: UICollectionViewCell {
    var counter: Int = 0
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        countLabel.text = "\(counter)"
    }
    
    @IBAction func tapCountButton(sender: AnyObject) {
        counter += 1
        countLabel.text = "\(counter)"
    }
}

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var questionLabel: UILabel!
    var pointData: [Int] = []
    var page = 0
    var data: [[String:String]] = [
        [
            "title":"お年はいくつですか？\n（2年までの誤差は正解）",
            "point":"2",
        ],
        [
            "title":"今日は何年の何月何日ですか？\n何曜日ですか？\n（年・月・日・曜日がそれぞれ１点ずつ）",
            "point":"5",
        ],
        [
            "title":"私たちが今いるところはどこですか？\n（自発的にできれば2点,5秒おいて家ですか?病院ですか?施設ですか?のなかから正しい選択をすれば1点）",
            "point":"3",
        ],
        [
            "title":"これから言う３つの言葉を言ってみてください。\nあとでまた聞きますのでよく覚えておいてください。",
            "select1":"桜、猫、電車",
            "select2":"梅、犬、自動車",
            "point":"4",
        ],
        [
            "title":"100から7を順番に引いいてください。\n（100-7は？、それからまた7を引くと？と質問する。最初の答えが不正かの場合、打ち切る）",
            "answer":"93、86",
            "point":"3"
        ],
        [
            "title":"私がこれから言う数字を逆から言ってください。\n（6-8-2、3-5-2-9を逆に行ってもらう、3桁逆唱に失敗したら、打ち切る）",
            "answer":"2-8-6、9-2-5-3",
            "point":"3",
        ],
        [
            "title":"先ほど覚えてもらった言葉をもう一度言ってみてください。\n（自発的に回答があれば各2点、もし回答がない場合以下のヒントを与え正解であれば1点、\na)植物　b)動物　c)乗り物）",
            "loadAnswer":"answer3",
            "point":"7",

        ],
        [
            "title":"これから5つの品物を見せます。それを隠しますのでなにがあったか言ってください。\n（時計、鍵、タバコ、ペン、硬貨など必ず相互に無関係なもの）",
            "point":"6",
        ],
        [
            "title":"知ってる野菜の名前をできるだけ多く言ってください。\n（答えた野菜の名前を右欄に記入する。途中で詰まり、約10秒間待っても出ない場合にはそこで打ち切る）0〜5=0点、6=1点、7=2点、8=3点、9=4点、10=5点",
            "point":"6",
        ],
    ]
    var timer: NSTimer!
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let maxPoint = Int(data[page]["point"]!)
        for i in 0..<maxPoint! {
            pointData.append(i)
        }
        
        guard let question = data[page]["title"] else {
            return
        }
        if let answer = data[page]["answer"] {
            questionLabel.text = "\(question)\n\n答え：\(answer)"
        }
        else if data[page]["select1"] != nil {
            let random = arc4random()%2 + 1
            let select = "select\(random)"
            questionLabel.text = "\(question)\n\n選んだもの：\(data[page][select]!)"
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(data[page][select]!, forKey: "answer\(page)")
            defaults.synchronize()
        }
        else if let key = data[page]["loadAnswer"] {
            let defualts = NSUserDefaults.standardUserDefaults()
            let answer = defualts.objectForKey(key) as? String
            questionLabel.text = "\(question)\n\n答え：\(answer!)"
        }
        else {
            questionLabel.text = question
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        PointManager.removeIndex(page)
        navigationItem.title = "0秒"
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.updateLabel), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        timer.invalidate()
        count = 0
    }
    
    func updateLabel() {
        count += 1
        navigationItem.title = "\(count)秒"
    }
    
    func loadData() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var supplementaryView = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath)
        }
        return supplementaryView
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if page == 8 {
            return self.pointData.count + 1
        }
        else {
            return self.pointData.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if page == 8 {
            if pointData.count == indexPath.row {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("buttonCell", forIndexPath: indexPath) as! ButtonCell
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PointCell
                cell.pointLabel.text = String(pointData[indexPath.row])
                return cell
            }
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PointCell
            cell.pointLabel.text = String(pointData[indexPath.row])
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width: CGFloat = 80
        if view.frame.size.width / CGFloat(pointData.count) > 80 {
            width = view.frame.size.width / CGFloat(pointData.count)
        }
        return CGSizeMake(width, 100)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        self.cellAnimation(cell)
    }
    
    func cellAnimation(cell: UICollectionViewCell) {
        /*UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            cell.frame.origin.y += 10
            }) { (Bool) in
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { 
                    cell.frame.origin.y -= 10
                    }, completion: { (Bool) in
                        self.cellAnimation(cell)
                })
        }*/
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == pointData.count {
            return
        }
        let point = pointData[indexPath.row]
        PointManager.addPoint(point)
        if page+1 != data.count {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            vc.page = page + 1
            navigationController?.showViewController(vc, sender: nil)
        }
        else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ResultViewController") as! ResultViewController
            navigationController?.showViewController(vc, sender: nil)
        }
    }
}


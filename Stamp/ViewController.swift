//
//  ViewController.swift
//  Stamp
//
//  Created by Rinazr on 2015/11/01.
//  Copyright © 2015年 Rinazr. All rights reserved.
//
//http://iscene.jimdo.com/2015/07/11/swift-scroll-uiscrollvie-%E7%94%BB%E5%83%8F%E3%82%92%E3%82%B9%E3%83%A9%E3%82%A4%E3%83%88-%E3%82%B9%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%AB%E3%81%95%E3%81%9B%E3%82%8B-%E6%A8%AA%E6%96%B9%E5%90%91/
//スクロール機能の追加
//スクロールを動かせるようにする

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    //スタンプ画像の名前が入った配列
    var imageNameArray = ["panda1","panda2","panda3","panda4","panda5","nezumi.png","tori.png","kuma.png","inu.png"]
    
    //選択しているスタンプの記号
    var imageIndex: Int = 0
    
    //判別
    var isImageInside = Bool!()
    
    
    //背景画像を表示させるImageView
    @IBOutlet var haikeiImageView: UIImageView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    //スタンプの画像が入るImageView
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //ここから：
        // 全体のサイズ ScrollViewフレームサイズ取得
        let SVSize = scrollView.frame.size
        
        //ここに書く❶
        
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.pagingEnabled = false
        scrollView.bounces = true
        scrollView.scrollEnabled = true
        
        
        for var i = 0; i < 9; i++ {
            let button = UIButton()
            button.tag = i
            print(button.tag)
            button.frame = CGRectMake(CGFloat(90 * i),5 ,80 ,80)
            button.setImage(UIImage(named: imageNameArray[i]),forState:  .Normal)
            button.addTarget(self, action: #selector(ViewController.selectedStamp), forControlEvents: .TouchUpInside)
            scrollView.addSubview(button)
            print("make bt")
            
        }
        
        scrollView.contentSize = CGSizeMake(80 * 10, 90)
        
        
    }
    
   
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //タッチされた位置を習得
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.locationInView(self.view)
        
        
        //もしimageIndexが0でない（押すスタンプが選ばれていない）時
        if imageIndex != 0 {
            //スタンプサイズを40pxの正方形に指定
            imageView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
            
            //押されたスタンプの画像を設定
            let image: UIImage = UIImage(named: imageNameArray[imageIndex - 1])!
            imageView.image = image
            
            if location.x < 320 - imageView.layer.bounds.width / 2 && location.y < 428 - imageView.layer.bounds.height / 2 {
                
                
                //タッチされた位置に画像を置く
                imageView.center = CGPointMake(location.x, location.y)
                
                //画面を表示する
                self.view.addSubview(imageView)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch: UITouch = touches.first! as UITouch
        
        let preDx = touch.previousLocationInView(self.view).x
        let preDy = touch.previousLocationInView(self.view).y
        
        
        // ドラッグ後の座標
        let newDx = touch.locationInView(self.view).x
        let newDy = touch.locationInView(self.view).y
        
        // ドラッグしたx座標の移動距離
        let dx = newDx - preDx
        print("x:\(dx)")
        
        // ドラッグしたy座標の移動距離
        let dy = newDy - preDy
        print("y:\(dy)")
        
        
        
        if newDx < 320 - imageView.layer.bounds.width / 2 && newDy < 428 - imageView.layer.bounds.height / 2 {
            
            // 移動分を反映させる
            imageView.frame.origin.x += dx
            imageView.frame.origin.y += dy
            
            
        }
        
        
        
        
        
    }

    @IBAction func back(){
        /*
        if !self.imageNameArray.isEmpty {
            let targetStamp = self.imageNameArray.popLast()
            targetStamp!.removeFromSuperview()
        }*/
        self.imageView.removeFromSuperview()
    }
    
    
    @IBAction func selectBackGround(){
        //UIImagePickerControllerのインスタンスをつくる
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        
        //フォトライブラリを使う設定をする
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        //フォトライブラリを呼び出す
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    //フォトライブラリから画像の選択が終わったら呼ばれるメソッド
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //imageに選んだ画像を設定する
        let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //そのimageを背景に設定する
        haikeiImageView.image = image
        //フォトライブラリを閉じる
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save() {
        //画面のスクリーンショットを取得
        let rect: CGRect = CGRectMake(0, 30, 320, 380)
        UIGraphicsBeginImageContext(rect.size)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let capture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //フォトライブラリに保存
        
        UIImageWriteToSavedPhotosAlbum(capture, nil, nil, nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func takePhptpo(){
        
        //カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            //カメラを起動する
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            
            //カメラを自由に開きたい時（今回は正方形）
            picker.allowsEditing = true
            
            presentViewController(picker, animated: true, completion: nil)
            
        }else{
            //カメラが利用できない時はerrorがコンソールに表示される
            print("error")
        }
        
    }
    
    //functionここに書く
    
    func selectedStamp (sender:UIButton){
        
        switch sender.tag {
        case 0:
            imageIndex = 1
            print("selected 0")
        case 1:
            imageIndex = 2
            print("selected 1")
        case 2:
            imageIndex = 3
            print("selected 2")
        case 3:
            imageIndex = 4
            print("selected 3")
        case 4:
            imageIndex = 5
            print("selected 4")
        case 5:
            imageIndex = 6
            print("selected 5")
        case 6:
            imageIndex = 7
            print("selected 6")
        case 7:
            imageIndex = 8
            print("selected 7")
        case 8:
            imageIndex = 9
            print("selected 8")
        
        default:
            break
        }
    }
    
    
}












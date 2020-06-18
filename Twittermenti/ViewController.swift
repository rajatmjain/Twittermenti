//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON
import Alamofire


class ViewController: UIViewController {
    
    let stockUrl = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=MSFT&interval=5min&apikey=E7RXDN4Y7E95TZPN"
    
    
    
    
    
    let swifter = Swifter(consumerKey:
        "iyqWdKnnEeSsHkNjmdnWxJ56p", consumerSecret: "lY0GTXUpnFElVW8pn3Q0wi0hXu2Q0xZ4KPYzlQ0nmhiynsG74S")

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
 let tweetCount = 100
    
    let sentimentClassifier = twitSenti()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     }

    @IBAction func predictPressed(_ sender: Any) {
      fetchTweets()
    
    }
    
    func fetchTweets(){
          if let searchText = textField.text{
                     
                    swifter.searchTweet(using: searchText,lang: "en", count: tweetCount ,tweetMode: .extended, success: { (results, metadata) in
                                  print(results)
                        //            print(metadata)
                        
                        var tweetsArray = [twitSentiInput]()
                       
                        for i in 0..<100{
                            
                            if let tweet = results[i]["full_text"].string{
                                let tweetForClassification = twitSentiInput(text: tweet)
                                tweetsArray.append(tweetForClassification)
                               
                            }
                            
                            
                           
                        }
                        
                        
                        self.makePrediction(with: tweetsArray)
                    }) { (error) in
                        print("Error:",error)
                    }
                    
                }
                
    }
    
    func makePrediction(with tweetsArray : [twitSentiInput]){
        do{
                                
                                let prediction = try self.sentimentClassifier.predictions(inputs: tweetsArray)
                                
        var sentimentalScore = 0
                                
                                for pred in prediction{
                                    print(pred.label)
                                    if pred.label == "Pos"{
                                        sentimentalScore = sentimentalScore + 1
                                    }
                                    else if pred.label == "Neg"{
                                       sentimentalScore = sentimentalScore-1
                                    }
                                }
                                
                             updateUI(with: sentimentalScore)
                            }
                            catch{
                                print("Error yo!")
                            }
    }
    
    func updateUI(with sentimentalScore : Int){
        
        if sentimentalScore > 20 {
            self.sentimentLabel.text = "😍"
        }
        else if sentimentalScore > 10 {
            self.sentimentLabel.text = "😄"
        }
        else if sentimentalScore > 0 {
            self.sentimentLabel.text = "🙂"
        }
        else if sentimentalScore == 0 {
            self.sentimentLabel.text = "😐"
        }
        else if sentimentalScore > -10{
            self.sentimentLabel.text = "😕"
        }
        else if sentimentalScore > -20 {
            self.sentimentLabel.text = "😡"
        }
        else {
            self.sentimentLabel.text = "🤮"
        }
        
        
        print("Sentimental Score is "+"\(sentimentalScore)")
        
    }
   
//    func getStockData(){
//        Alamofire.request(stockUrl, method: .get ).responseJSON(){
//            response in
//            if response.result.isSuccess{
//                let stockJSON : JSON = JSON(response.result.value!)
//                print(stockJSON)
//            }
//            else{
//                print("Error"+"\(Error.self)")
//            }
//        }
//        }
    
    
    }
    



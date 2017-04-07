

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var todoListTableView: UITableView!
    @IBOutlet weak var txtTitle: UITextField!
    
    var todoList = NSMutableArray()
    var selectedDate = Date()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        read()

        
    }
    
    //すでに存在するデータの読み込み処理
    func read(){
        
        //配列初期化
        todoList = NSMutableArray()
        
        //AppDelegateを使う準備をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //どのエンティティからdataを取得してくるか設定
        let query: NSFetchRequest<TODO> = TODO.fetchRequest()
        
        do{
        //データを一括取得
            let fetchResults = try viewContext.fetch(query)
        
        //データの取得
            for result: AnyObject in fetchResults{
                
                let title: String? = result.value(forKey: "title") as? String
                
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                
                print("title:\(title) saveDate:\(saveDate)")
                
                todoList.add(["title":title, "saveDate":saveDate])
            }
            }catch{
        }
        todoListTableView.reloadData()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var dic = todoList[indexPath.row] as! NSDictionary
        
        cell.textLabel?.text = dic["title"] as! String
        
        //文字を設定したセルを返す
        return cell
    }


    //追加ボタンが押された時
    @IBAction func tapToAdd(_ sender: UIButton) {
        
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //TODOエンティティオブジェクトを作成
        let ToDo = NSEntityDescription.entity(forEntityName: "TODO", in: viewContext)
        
        //TODOエンティティにレコード（行）を挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)
        
        //値のセット
        newRecord.setValue(txtTitle.text, forKey: "title")//値を代入
        newRecord.setValue(Date(), forKey:"saveDate")//値を代入
        
        do {
            //レコード（行）の即時保存
            try viewContext.save()
            
            //再読み込み
            read()
            
        }catch{
    
        }
    }


    //リターンキーが押された時
    @IBAction func tapToReturn(_ sender: UITextField) {
    }
    
    //削除のボタンが押された時
    @IBAction func toaToDelete(_ sender: UIButton) {
        
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TODO> = TODO.fetchRequest()
        
        do{
        
        //削除するデータを取得
            let fetchResults = try viewContext.fetch(request)
            for result: AnyObject in fetchResults{
                let record = result as! NSManagedObject
                
                //１行ずつ削除
                viewContext.delete(record)
                
            }
    //削除した状態を保存
            try viewContext.save()
            
            read()
            
        }catch{
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
}


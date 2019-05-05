//
//  CoreDataVC.swift
//  XZQDemo_swift
//
//  Created by 项正强 on 2018/1/13.
//  Copyright © 2018年 项正强. All rights reserved.
//

import UIKit
import CoreData
class CoreDataVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate {
    lazy var myTab:UITableView = {
        () -> UITableView in
        let tableView = UITableView(frame: CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: self.view.frame.size.height - 100), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        return tableView
    }()
    
    lazy var fetchedResultsController = {
        () -> NSFetchedResultsController<NSFetchRequestResult> in
        let sort:NSSortDescriptor = NSSortDescriptor(key: "age", ascending: true)
        let request = NSFetchRequest<Student>(entityName: "Student")
        request.sortDescriptors = [sort]
        let fetch = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>, managedObjectContext: ZQCoreDataManager.shareInstance.managerObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetch.delegate = self
        do {
            try fetch.performFetch()
        } catch  {
            print("查询失败")
        }
        return fetch
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        self.createBtns()
        self.view.addSubview(self.myTab)
    }
    
    func add(){
        //获取学生表
        let student:Student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: ZQCoreDataManager.shareInstance.managerObjectContext) as! Student
        student.age = Int16(arc4random() % 30)
        student.name = "项\(arc4random() % 30)"
        student.sex = Bool(truncating: arc4random() % 2 == 0 ? 1 : 0)
        print("新增成功")
        ZQCoreDataManager.shareInstance.save()
    }
    func delete(){
        //获取学生数据表
        let entity = NSEntityDescription.entity(forEntityName: "Student", in: ZQCoreDataManager.shareInstance.managerObjectContext)
        //创建删除条件
        let predicate = NSPredicate(format: "age=0", argumentArray: nil)
        //创建请求
        let request = NSFetchRequest<Student>()
        request.entity = entity
        request.predicate = predicate
        //获取符合条件的结果
        do {
            var fetchObjects:[Student]!
            fetchObjects = try ZQCoreDataManager.shareInstance.managerObjectContext.fetch(request)
            if fetchObjects.count > 0 {
                for student:Student in fetchObjects {
                    ZQCoreDataManager.shareInstance.managerObjectContext.delete(student)
                }
                print("删除成功")
                ZQCoreDataManager.shareInstance.save()
            }else{
                print("没有符合条件的数据")
            }
            
        } catch  {
            print("查询失败")
        }
        
        
        
    }
    func update(){
        //获取学生数据表
        let entity = NSEntityDescription.entity(forEntityName: "Student", in: ZQCoreDataManager.shareInstance.managerObjectContext)
        //创建删除条件
        let predicate = NSPredicate(format: "age<10", argumentArray: nil)
        //创建请求
        let request = NSFetchRequest<Student>()
        request.entity = entity
        request.predicate = predicate
        //获取符合条件的结果
        do {
            var fetchObjects:[Student]!
            fetchObjects = try ZQCoreDataManager.shareInstance.managerObjectContext.fetch(request)
            if fetchObjects.count > 0 {
                for student:Student in fetchObjects {
                    student.name = "已改名：\(student.name!)"
                    student.age += 10
                }
                print("修改成功")
                ZQCoreDataManager.shareInstance.save()
            }else{
                print("没有符合条件的数据")
            }
            
        } catch  {
            print("查询失败")
        }
    }
    func select(){
        //实例学生数据表
        let entity = NSEntityDescription.entity(forEntityName: "Student", in: ZQCoreDataManager.shareInstance.managerObjectContext)
        //查询到的数据按照年龄升序排列
        let sort = NSSortDescriptor(key: "age", ascending: true)
        //查询条件
        let predicate = NSPredicate(format: "age>20", argumentArray: nil)
        //请求
        let request = NSFetchRequest<Student>()
        request.entity = entity
        request.sortDescriptors = [sort]
        request.predicate = predicate
        //查询结果
        do {
            var fetchObjects:[Student]!
            fetchObjects = try ZQCoreDataManager.shareInstance.managerObjectContext.fetch(request)
            print("查询到\(fetchObjects.count)个年龄大于20的学生")
        } catch  {
            print("查询失败")
        }
    }
    
    
    //创建增删改查按钮
    func createBtns(){
        let butsNameArray:Array<String> = ["增","删","改","查"]
        let btnW:CGFloat = 50.0
        for i in 0...butsNameArray.count - 1 {
            let name:String = butsNameArray[i]
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: CGFloat(i) * (btnW + 10.0), y: btnW, width: btnW, height: btnW)
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = 5
            button.layer.masksToBounds = true
            button.setTitle(name, for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.addTarget(self, action:  #selector(touchBtnAction(button:)), for: UIControlEvents.touchUpInside)
            button.tag = 10 + i
            self.view.addSubview(button)
        }
    }
    //点击事件
    @objc func touchBtnAction(button:UIButton){
        switch button.tag {
        case 10:
            self.add()
            break
        case 11:
            self.delete()
            break
        case 12:
            self.update()
            break
        case 13:
            self.select()
            break
            
        default:
            break
        }
    }
    
    //NSFetchedResultsControllerDelegate 当数据有变动的时候就会调用
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.myTab.beginUpdates()
            self.myTab.insertRows(at: [newIndexPath!], with: .fade)
            self.myTab.reloadData()
            self.myTab.endUpdates()
            break
        case .delete:
            self.myTab.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            self.myTab.reloadRows(at: [indexPath!], with: .fade)
            break
        default:
            break
        }
    }
    
    //tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = self.fetchedResultsController.sections![section]
        return info.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let stu:Student = self.fetchedResultsController.object(at: indexPath) as! Student
        cell?.textLabel?.text = "姓名：\(stu.name!) 年龄：\(stu.age) 性别：\(stu.sex == true ? "男":"女")"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let stu:NSManagedObject = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
            //删除数据
            ZQCoreDataManager.shareInstance.managerObjectContext.delete(stu)
            //保存结果
            ZQCoreDataManager.shareInstance.save()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

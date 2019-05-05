//
//  ZQCoreDataManager.swift
//  XZQDemo_swift
//
//  Created by 项正强 on 2018/1/12.
//  Copyright © 2018年 项正强. All rights reserved.
//

import UIKit
//导入coredata框架
import CoreData
final class ZQCoreDataManager: NSObject {
    //创建单例
    static let shareInstance = ZQCoreDataManager()
    private override init() {
        
    }
    
    /**
     获取数据库路径
     */
    private func getDocumentUrlPath() -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
    /**
     管理上下文
     */
    lazy var managerObjectContext = {
        () -> NSManagedObjectContext in
        /**
         参数:CoreData环境线程
         NSMainQueueConcurrencyType:主线程       储存无延迟
         NSPrivateQueueConcurrencyType:分支线程  存储有延迟
         */
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        //设置存储调度器
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context;
    }()
    
    /**
     模型对象
     */
    lazy var managerObjectModel = {
        () -> NSManagedObjectModel in
        /**
         参数是模型文件的bundle数组  如果是nil  自动获取所有bundle的模型文件
         */
        let model = NSManagedObjectModel.mergedModel(from: nil)
        return model!
    }()
    /**
     存储调度器
     */
    lazy var persistentStoreCoordinator = {
       () -> NSPersistentStoreCoordinator in
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managerObjectModel)
        
        let url = self.getDocumentUrlPath().appendingPathComponent("sqlit.db", isDirectory: true)
        /**
         参数：
         * type:一般使用数据库存储方式NSSQLiteStoreType
         * configuration:配置信息  一般无需配置
         * URL:要保存的文件路径
         * options:参数信息 一般无需设置
         */
        coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        return coordinator;
    }()
    
    
    /**
     保存数据
     */
    public func save(){
        do {
            try self.managerObjectContext.save()
            print("数据操作成功")
        } catch  {
            print("数据操作失败")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

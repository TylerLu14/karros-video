//
//  Scheduler.swift
//  karros-video
//
//  Created by Hoang Lu on 4/21/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

let scheduler = Scheduler.sharedScheduler

public class Scheduler {
    
    public static let sharedScheduler = Scheduler()
    
    public let backgroundScheduler: ImmediateSchedulerType
    public let mainScheduler: SerialDispatchQueueScheduler
    
    init() {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10
        operationQueue.qualityOfService = QualityOfService.userInitiated
        
        backgroundScheduler = OperationQueueScheduler(operationQueue: operationQueue)
        mainScheduler = MainScheduler.instance
    }
}

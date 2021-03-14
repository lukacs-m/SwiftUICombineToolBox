//
//  File.swift
//  
//
//  Created by Martin Lukacs on 14/03/2021.
//

import Combine
import Network

public enum NerworkType {
    case wifi
    case cellular
    case loopBack
    case wired
    case other
}

public protocol ReachabilityServiceContract {
    var reachabilityInfos: PassthroughSubject<NWPath, Never> { get set }
    var isNetworkAvailable: CurrentValueSubject<Bool, Never> { get set }
    var typeOfCurrentConnection: PassthroughSubject<NerworkType, Never> { get set }
}

final public class ReachabilityService: ReachabilityServiceContract {
    public var reachabilityInfos: PassthroughSubject<NWPath, Never> = .init()
    public var isNetworkAvailable: CurrentValueSubject<Bool, Never> = .init(false)
    public var typeOfCurrentConnection: PassthroughSubject<NerworkType, Never> = .init()

    private let monitor: NWPathMonitor
    private let backgroudQueue = DispatchQueue.global(qos: .background)

    public init() {
        monitor = NWPathMonitor()
        setUp()
    }
    
    public init(with interFaceType: NWInterface.InterfaceType) {
        monitor = NWPathMonitor(requiredInterfaceType: interFaceType)
        setUp()
    }
    
    deinit {
        monitor.cancel()
    }
}

private extension ReachabilityService {
    func setUp() {
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.reachabilityInfos.send(path)
            switch path.status {
            case .satisfied:
                self?.isNetworkAvailable.send(true)
            case .unsatisfied, .requiresConnection:
                self?.isNetworkAvailable.send(false)
            @unknown default:
                self?.isNetworkAvailable.send(false)
            }
            if path.usesInterfaceType(.wifi) {
                self?.typeOfCurrentConnection.send(.wifi)
            } else if path.usesInterfaceType(.cellular) {
                self?.typeOfCurrentConnection.send(.cellular)
            } else if path.usesInterfaceType(.loopback) {
                self?.typeOfCurrentConnection.send(.loopBack)
            } else if path.usesInterfaceType(.wiredEthernet) {
                self?.typeOfCurrentConnection.send(.wired)
            } else if path.usesInterfaceType(.other) {
                self?.typeOfCurrentConnection.send(.other)
            }
        }
        
        monitor.start(queue: backgroudQueue)
    }
}

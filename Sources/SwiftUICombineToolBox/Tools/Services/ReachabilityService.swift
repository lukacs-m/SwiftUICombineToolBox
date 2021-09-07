//
//  File.swift
//  
//
//  Created by Martin Lukacs on 14/03/2021.
//

import Combine
import Network

/// Types of network
public enum NerworkType {
    case wifi
    case cellular
    case loopBack
    case wired
    case other
    case unknown
}

/// Protocol containing the current device network states and informations
public protocol ReachabilityServicing {
    /// All NWpath informations
    var reachabilityInfos: CurrentValueSubject<NWPath?, Never> { get set }
    /// Is network currently available
    var isNetworkAvailable: CurrentValueSubject<Bool, Never> { get set }
    /// Type of current connection
    var typeOfCurrentConnection: CurrentValueSubject<NerworkType, Never> { get set }
}

/// Helps keep up on the device network state through combine publishers
final public class ReachabilityService: ReachabilityServicing {
    public var reachabilityInfos: CurrentValueSubject<NWPath?, Never> = .init(nil)
    public var isNetworkAvailable: CurrentValueSubject<Bool, Never> = .init(false)
    public var typeOfCurrentConnection: CurrentValueSubject<NerworkType, Never> = .init(.unknown)

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
            } else {
                self?.typeOfCurrentConnection.send(.unknown)
            }
        }
        
        monitor.start(queue: backgroudQueue)
    }
}

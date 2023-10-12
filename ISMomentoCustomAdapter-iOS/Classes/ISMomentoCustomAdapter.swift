//
//  ISMomentoAdapter.swift
//  ironSourceCustomAdapter
//
//  Created by Minhyun Cho on 2023/05/24.
//

import Foundation
import Momento_iOS
import IronSource

@objc(ISMomentoCustomAdapter)
public class ISMomentoCustomAdapter: ISBaseNetworkAdapter {
    
    var customAdapterVersion: String = "0.0.1"
    
    public override func `init`(_ adData: ISAdData!, delegate: ISNetworkInitializationDelegate!) {
        // Error-Handling 코드가 추가된 경우 delegate.onInitDidFailWithErrorCode(<#T##errorCode: Int##Int#>, errorMessage: <#T##String?#>) 추가 구현 필요.
        delegate.onInitDidSucceed()
        return
    }
    
    public override func networkSDKVersion() -> String! {
        return MomentSDK.shared.getMomentoVersion()
    }
    
    public override func adapterVersion() -> String! {
        return self.customAdapterVersion
    }
    
    public func setRewardVideoSkipEnabled(_ state: Bool) {
        MomentSDK.shared.setRewardVideoSkipEnabled(state)
    }
}

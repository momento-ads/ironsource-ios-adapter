//
//  ISMomentoCustomRewardedVideo.swift
//  ironSourceCustomAdapter
//
//  Created by Minhyun Cho on 2023/05/30.
//

import Foundation
import Momento_iOS
import IronSource

@objc(ISMomentoCustomRewardedVideo)
public class ISMomentoCustomRewardedVideo : ISBaseRewardedVideo {
    
    private let momentoKey: String = "unitid"
    private var isAdLoaded: Bool = false
    
    private var moVideoManager: MomentVideoManager?
    
    private var ironSourceDelegate: ISRewardedVideoAdDelegate?
    
    override public func loadAd(with adData: ISAdData, delegate: ISRewardedVideoAdDelegate) {
        self.ironSourceDelegate = delegate
        let keyValue = adData.getString(momentoKey)
        if let unitId = keyValue {
            moVideoManager = MomentVideoManager(unitID: unitId)
            moVideoManager?.videoDelegate = self
            moVideoManager?.loadVideo()
        } else {
            delegate.adDidFailToLoadWith(ISAdapterErrorType.internal, errorCode: ISAdapterErrors.missingParams.rawValue, errorMessage: "ISMomentoCustomAdapter :: Invalid UnitID.")
        }
    }
    
    override public func showAd(with viewController: UIViewController, adData: ISAdData, delegate: ISRewardedVideoAdDelegate) {
        self.ironSourceDelegate = delegate
        guard let moVideoManager = moVideoManager else {
            delegate.adDidFailToShowWithErrorCode(ISAdapterErrorType.internal.rawValue, errorMessage: "ISMomentoCustomAdapter :: No Video Manager Instance.")
            return
        }
        
        if self.isAdAvailable(with: adData) {
            moVideoManager.showVideo()
        } else {
            delegate.adDidFailToShowWithErrorCode(ISAdapterErrorType.noFill.rawValue, errorMessage: "ISMomentoCustomAdapter :: Couldn't show ad. Ad is not ready to show.")
        }
    }
    
    override public func isAdAvailable(with adData: ISAdData) -> Bool {
        if let moVideoManager = moVideoManager {
            return moVideoManager.hasVideoAd()
        }
        return false
    }
}

extension ISMomentoCustomRewardedVideo: MomentVideoDelegate {
    public func onVideoLoaded(dspName: String) {
        print("MomentoRewardedVideoManager - onVideoLoaded(\(dspName))")
        ironSourceDelegate?.adDidLoad()
    }
    
    public func onVideoComplete() {
        print("MomentoRewardedVideoManager - onVideoComplete()")
        ironSourceDelegate?.adDidEnd()
    }
    
    public func onVideoRewarded(state: Bool) {
        print("MomentoRewardedVideoManager - onVideoRewarded(\(state))")
        if state { ironSourceDelegate?.adRewarded() }
    }
    
    public func onVideoLoadFailed(description: String) {
        print("MomentoRewardedVideoManager - onVideoLoadFailed(\(description)")
        ironSourceDelegate?.adDidFailToLoadWith(.noFill, errorCode: 20401, errorMessage: "\(description)")
    }
    
    public func onVideoShowFailed(description: String) {
        print("MomentoRewardedVideoManager - onVideoShowFailed(\(description)")
        ironSourceDelegate?.adDidFailToShowWithErrorCode(90016, errorMessage: "\(description)")
    }
    
    public func onVideoTimedout() {
        print("MomentoRewardedVideoManager - onVideoTimedout()")
    }
    
    public func onVideoShown() {
        print("MomentoRewardedVideoManager - onVideoShown()")
        ironSourceDelegate?.adDidOpen()
        ironSourceDelegate?.adDidStart()
        ironSourceDelegate?.adDidShowSucceed()
        ironSourceDelegate?.adDidBecomeVisible()
    }
    
    public func onVideoClosed() {
        print("MomentoRewardedVideoManager - onVideoClosed()")
        ironSourceDelegate?.adDidClose()
    }
    
    public func onVideoRemoved() {
        print("MomentoRewardedVideoManager - onVideoRemoved()")
    }
    
    public func onVideoClicked(type: Momento_iOS.MomentSDK.videoClickType) {
        print("MomentoRewardedVideoManager - onVideoClicked(\(type))")
        ironSourceDelegate?.adDidClick()
    }
}

//
//  ISMomentoCustomInterstitial.swift
//  ironSourceCustomAdapter
//
//  Created by Minhyun Cho on 2023/05/30.
//

import Foundation
import Momento_iOS
import IronSource

@objc(ISMomentoCustomInterstitial)
public class ISMomentoCustomInterstitial: ISBaseInterstitial {
    
    private let momentoKey: String = "unitid"
    private var isAdLoaded: Bool = false
    
    private var moVideoManager: MomentVideoManager?
    
    private var ironSourceDelegate: ISInterstitialAdDelegate?
    
    override public func loadAd(with adData: ISAdData, delegate: ISInterstitialAdDelegate) {
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
    
    override public func showAd(with viewController: UIViewController, adData: ISAdData, delegate: ISInterstitialAdDelegate) {
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
/**
 - load*
 - end*
 - close*
 - open*
 - click*
 - start
 - shown*
 - visible
 */

extension ISMomentoCustomInterstitial: MomentVideoDelegate {
    public func onVideoLoaded(dspName: String) {
        print("MomentoInterstitialVideoManager - onVideoLoaded(\(dspName)")
        ironSourceDelegate?.adDidLoad()
    }
    
    public func onVideoComplete() {
        print("MomentoInterstitialVideoManager - onVideoComplete()")
        ironSourceDelegate?.adDidEnd()
    }
    
    public func onVideoRewarded(state: Bool) {
        print("MomentoInterstitialVideoManager - onVideoRewarded(\(state)")
    }
    
    public func onVideoLoadFailed(description: String) {
        print("MomentoInterstitialVideoManager - onVideoLoadFailed(\(description)")
        ironSourceDelegate?.adDidFailToLoadWith(.noFill, errorCode: 20401, errorMessage: "\(description)")
    }
    
    public func onVideoShowFailed(description: String) {
        print("MomentoInterstitialVideoManager - onVideoShowFailed(\(description)")
        ironSourceDelegate?.adDidFailToShowWithErrorCode(90016, errorMessage: "\(description)")
        
    }
    
    public func onVideoTimedout() {
        print("MomentoInterstitialVideoManager - onVideoTimedout()")
        ironSourceDelegate?.adDidFailToLoadWith(.noFill, errorCode: 40801, errorMessage: "onVideoTimedOut")
    }
    
    public func onVideoShown() {
        print("MomentoInterstitialVideoManager - onVideoShown()")
        ironSourceDelegate?.adDidOpen()
        ironSourceDelegate?.adDidStart()
        ironSourceDelegate?.adDidShowSucceed()
        ironSourceDelegate?.adDidBecomeVisible()
    }
    
    public func onVideoClosed() {
        print("MomentoInterstitialVideoManager - onVideoClosed()")
        ironSourceDelegate?.adDidClose()
    }
    
    public func onVideoRemoved() {
        print("MomentoInterstitialVideoManager - onVideoRemoved()")
    }
    
    public func onVideoClicked(type: Momento_iOS.MomentSDK.videoClickType) {
        print("MomentoInterstitialVideoManager - onVideoClicked(\(type)")
        ironSourceDelegate?.adDidClick()
    }
}

Pod::Spec.new do |s|
  s.name             = 'ISMomentoCustomAdapter-iOS'
  s.version          = '0.0.3'
  s.summary          = 'IronSource X Momento Custom Adapter'
  s.homepage         = 'https://github.com/momento-ads/ironsource-ios-adapter'

  s.description      = <<-DESC
	ISMomentoCustomAdapter-iOS swift
	More details? Check our github page.
                       DESC

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iOS-Minhyun' => 'cho.minhyun@cashwalk.io' }
  s.source           = { :git => 'https://github.com/momento-ads/ironsource-ios-adapter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'ISMomentoCustomAdapter-iOS/Classes/**/*'
#  s.resources = 'ISMomentoCustomAdapter-iOS/Assets/**/*'
  s.static_framework = true
  
  s.dependency 'Momento_iOS'
  s.dependency 'IronSourceSDK'
  
end

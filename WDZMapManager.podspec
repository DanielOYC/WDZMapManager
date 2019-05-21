#
# Be sure to run `pod lib lint WDZMapManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WDZMapManager'
  s.version          = '0.1.2'
  s.summary          = '基于高德地图的二次封装'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/DanielOYC/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DanielOYC' => '775350532@qq.com' }
  s.source           = { :git => 'https://github.com/DanielOYC/WDZMapManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.subspec 'WDZLocationKit' do |ss|
      
      ss.source_files = 'WDZMapManager/Classes/WDZLocationKit/**/*'
      
      ss.frameworks = 'ExternalAccessory','GLKit','Security','CoreTelephony','SystemConfiguration','CoreLocation'
      
      ss.ios.vendored_frameworks = 'WDZMapManager/Classes/AMap_iOSSDK/AMapFoundationKit.framework',
                                    'WDZMapManager/Classes/AMap_iOSSDK/AMapLocationKit.framework',
                                    'WDZMapManager/Classes/AMap_iOSSDK/AMapSearchKit.framework',
                                    'WDZMapManager/Classes/AMap_iOSSDK/MAMapKit.framework'
      
      ss.libraries = 'c++','z'
      
      #ss.public_header_files = 'WDZMapManager/Classes/WDZLocationKit/KDLocationManager.h'
      
  end
  
  #s.subspec 'KDMapViewKit' do |ss|
  #
  #  ss.source_files = 'KDMapManager/Classes/KDMapViewKit/**/*'
  #
  #  ss.frameworks = 'ExternalAccessory','GLKit','Security','CoreTelephony','SystemConfiguration','CoreLocation'
  #
  #  ss.ios.vendored_frameworks = 'KDMapManager/Classes/AMap_iOSSDK/AMapFoundationKit.framework',
  #                               'KDMapManager/Classes/AMap_iOSSDK/AMapLocationKit.framework',
  #                               'YCTestKit/Classes/AMap_iOSSDK/MAMapKit.framework',
  #                               'KDMapManager/Classes/AMap_iOSSDK/AMapSearchKit.framework'
  #
  #  ss.libraries = 'c++','z'
  #
  #  #ss.public_header_files = 'KDMapManager/Classes/KDLocationKit/KDLocationManager.h'
  #
  #end
end

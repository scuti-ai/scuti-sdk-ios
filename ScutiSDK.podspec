#
# Be sure to run `pod lib lint ScutiSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ScutiSDK'
  s.version          = '0.1.1'
  s.summary          = 'Scuti SDK - gCommerce Marketplace'

    s.swift_versions = '4.0'
  s.description      = <<-DESC
Rewarded gCommerce marketplace built for gamers.
                       DESC

  s.homepage         = 'https://scuti.store/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MindTrust' => 'mindtrust@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/scuti-ai/scuti-sdk-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '14.0'

  s.source_files = 'ScutiSDK/Classes/**/*'
  
end

#
# Be sure to run `pod lib lint CocoaPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CocoaPlayer"
  s.version          = "0.1.0"
  s.summary          = "Simple library that makes and parses VAST responses and then plays videos & ads for iOS"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
CocoaPlayer will allow you to make request to any VAST 2.0 compliant server to retrieve a VAST tag representing the ads and video to play. It will then play those pre-roll ads before playing the main video. Includes support for HLS so you can play adaptive bitrate videos.
                       DESC

  s.homepage         = "https://github.com/stephen-deg/CocoaPlayer"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Stephen Deguglielmo" => "stephen.deg@gmail.com" }
  s.source           = { :git => "https://github.com/stephen-deg/CocoaPlayer.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'CocoaPlayer' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'GoogleAds-IMA-iOS-SDK', '~>3.0.beta.16'
end

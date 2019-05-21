#
#  Be sure to run `pod spec lint GuidePageHUD.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "GuidePageHUD"
  spec.version      = "0.0.1"
  spec.summary      = ""
  spec.description  = <<-DESC
                   DESC

  spec.homepage     = "https://github.com/wuwulailai/GuidePageHUD"
  spec.license      = {:type => "MIT", :file => "LICENSE"}
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "Talos" => "email@address.com" }

  spec.source       = { :git => "https://github.com/wuwulailai/GuidePageHUD.git", :commit => "77dbc389301835b21cb633a9a7c9ef68d658c0f2" }

  spec.source_files  = "GuidePageView/*.{h,m,swift}"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

end

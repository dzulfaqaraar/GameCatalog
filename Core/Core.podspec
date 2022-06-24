Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "Core"
s.summary = "Catalog Core.framework for modularization"
s.requires_arc = true
s.version = "1.0.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Dzulfaqar" => "dzulfaqar.aar@gmail.com" }
s.homepage = "https://github.com/dzulfaqaraar/CatalogCore"
s.source = { :git => "https://github.com/dzulfaqaraar/CatalogCore.git", :tag => "#{s.version}" }
s.framework = "UIKit"
s.source_files = "Core/**/*.{swift}"
#s.resources = "Core/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
s.swift_version = "5.6.1"

end
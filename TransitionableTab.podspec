Pod::Spec.new do |s|
  s.name         = "TransitionableTab"
  s.version      = "0.1.3"
  s.summary      = "between tab animation"
  s.description  = "TransitionableTab makes it easy to animate when switching between tab"
  s.homepage     = "https://github.com/Interactive-Studio/TransitionableTab"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "gwangbeom" => "battlerhkqo@naver.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/Interactive-Studio/TransitionableTab.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end

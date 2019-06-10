Pod::Spec.new do |s|
  s.name         = "OrzBLE"
  s.version      = "0.0.2"
  s.summary      = "Capsule of functions about bluetooth."
  s.description  = <<-DESC
just capsule functions about bluetooth into a single repo
                   DESC
  s.homepage     = "https://github.com/OrzGeeker/OrzBLE"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author             = { "wangzhizhou" => "824219521@qq.com" }
  s.social_media_url   = "https://github.com/wangzhizhou"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/OrzGeeker/OrzBLE.git", :tag => "#{s.version}" }
  s.source_files  = "OrzBLE/**/*.{h,hpp,m,mm,swift}"
  s.dependency "RxBluetoothKit", "~> 5.2.1"
  s.swift_version = "5.0"
end

#!/usr/bin/env ruby
require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)

target = project.targets.first

# Update the settings to use the bridging header
target.build_configurations.each do |config|
  config.build_settings['BRIDGING_HEADER'] = 'Sources/JailbreakShield/JailbreakShield-Bridging-Header.h'
  config.build_settings['SWIFT_OBJC_BRIDGING_HEADER'] = 'Sources/JailbreakShield/JailbreakShield-Bridging-Header.h'
  
  # Clear problematic settings
  config.build_settings['MODULEMAP_FILE'] = nil
  config.build_settings['DEFINES_MODULE'] = 'NO'
end

project.save
puts "✨ Bridging header configured successfully!"

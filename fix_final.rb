#!/usr/bin/env ruby
require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)

target = project.targets.first

# Update the settings for mixed language framework
target.build_configurations.each do |config|
  # Clear problematic settings
  config.build_settings['BRIDGING_HEADER'] = nil
  config.build_settings['MODULEMAP_FILE'] = nil
  config.build_settings['MODULEMAP_PRIVATE_FILE'] = nil
  
  # Set correct search paths for headers
  config.build_settings['HEADER_SEARCH_PATHS'] = '$(SRCROOT)/Sources/JailbreakShieldCore/include'
  config.build_settings['USER_HEADER_SEARCH_PATHS'] = '$(SRCROOT)/Sources/JailbreakShieldCore/include'
  config.build_settings['SYSTEM_HEADER_SEARCH_PATHS'] = '$(SRCROOT)/Sources/JailbreakShieldCore/include'
  
  # Ensure modules are enabled
  config.build_settings['CLANG_ENABLE_MODULES'] = 'YES'
  config.build_settings['DEFINES_MODULE'] = 'NO'  # Don't try to auto-generate module
  config.build_settings['SWIFT_ENABLE_OBJC_INTEROP'] = 'YES'
  
  # Set SWIFT_INCLUDE_PATHS
  config.build_settings['SWIFT_INCLUDE_PATHS'] = '$(SRCROOT)/Sources/JailbreakShieldCore/include'
end

project.save
puts "✨ Build settings cleaned up successfully!"

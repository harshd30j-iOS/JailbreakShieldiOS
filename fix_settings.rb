#!/usr/bin/env ruby
require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)

target = project.targets.first

# Update build settings for bridging header and umbrella header
target.build_configurations.each do |config|
  # Set the bridging header
  config.build_settings['BRIDGING_HEADER'] = 'Sources/JailbreakShield/JailbreakShield-Bridging-Header.h'
  
  # Set umbrella header path
  config.build_settings['UMBRELLA_HEADER_PATH'] = '$(SRCROOT)/Sources/JailbreakShieldCore/include/JailbreakShield.h'
  
  # Ensure module is defined
  config.build_settings['DEFINES_MODULE'] = 'YES'
  
  # Enable Objective-C bridging
  config.build_settings['SWIFT_ENABLE_OBJC_INTEROP'] = 'YES'
end

# Also ensure the main project settings have these
project.build_configurations.each do |config|
  config.build_settings['ALWAYS_SEARCH_USER_PATHS'] = 'NO'
  config.build_settings['CLANG_ENABLE_MODULES'] = 'YES'
end

project.save
puts "✨ Build settings updated successfully!"

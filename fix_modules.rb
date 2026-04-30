#!/usr/bin/env ruby
require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)

target = project.targets.first

# Update the umbrella header setting
target.build_configurations.each do |config|
  config.build_settings['BRIDGING_HEADER'] = nil  # Remove bridging header
  
  # Set path to headers - use a relative path that works for the umbrella header
  config.build_settings['PRIVATE_HEADERS_FOLDER_PATH'] = '$(PRODUCT_NAME).framework/PrivateHeaders'
  
  # Try to use the module map
  config.build_settings['MODULEMAP_FILE'] = 'Sources/JailbreakShieldCore/include/module.modulemap'
  config.build_settings['MODULEMAP_PRIVATE_FILE'] = nil
  
  # Ensure modules are enabled
  config.build_settings['CLANG_ENABLE_MODULES'] = 'YES'
  config.build_settings['DEFINES_MODULE'] = 'YES'
  
  # Set correct search paths
  config.build_settings['HEADER_SEARCH_PATHS'] = '$(SRCROOT)/Sources/JailbreakShieldCore/include'
  config.build_settings['USER_HEADER_SEARCH_PATHS'] = '$(SRCROOT)/Sources/JailbreakShieldCore/include'
  
  # Ensure Swift-ObjC interop is enabled
  config.build_settings['SWIFT_ENABLE_OBJC_INTEROP'] = 'YES'
  
  # Set SWIFT_INCLUDE_PATHS so Swift can find clang modules
  config.build_settings['SWIFT_INCLUDE_PATHS'] = '$(SRCROOT)/Sources/JailbreakShieldCore/include'
end

# Also update the main project settings
project.build_configurations.each do |config|
  config.build_settings['CLANG_ENABLE_MODULES'] = 'YES'
end

project.save
puts "✨ Module settings updated successfully!"

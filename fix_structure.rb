#!/usr/bin/env ruby
require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)

target = project.targets.first
main_group = project.main_group

# Define the new file structure with proper paths
files_to_add = {
  'Sources/JailbreakShieldCore/include/HDJailbreakDetection.h' => 'Detection',
  'Sources/JailbreakShieldCore/HDJailbreakDetection.m' => 'Detection',
  'Sources/JailbreakShieldCore/include/HDSecurityBlockViewController.h' => 'SecurityUI',
  'Sources/JailbreakShieldCore/HDSecurityBlockViewController.m' => 'SecurityUI',
  'Sources/JailbreakShieldCore/include/HDSecurityBlockWindow.h' => 'SecurityUI',
  'Sources/JailbreakShieldCore/HDSecurityBlockWindow.m' => 'SecurityUI',
  'Sources/JailbreakShieldCore/include/ScreenProtectionManager.h' => 'ScreenProtection',
  'Sources/JailbreakShieldCore/ScreenProtectionManager.m' => 'ScreenProtection',
  'Sources/JailbreakShield/JailbreakShield.swift' => 'Swift'
}

# Clear existing build phases
sources_phase = target.source_build_phase
headers_phase = target.headers_build_phase

sources_phase.files.each { |file| sources_phase.remove_file_reference(file.file_ref) }
headers_phase.files.each { |file| headers_phase.remove_file_reference(file.file_ref) }

# Remove all files from the project
main_group.recursive_children_groups.each(&:clear)
main_group.files.each(&:remove_from_project)

# Re-add files in the new structure
groups = {}
files_to_add.each do |file_path, group_name|
  full_path = File.expand_path("~/Desktop/JailbreakShield/#{file_path}")
  
  unless File.exist?(full_path)
    puts "⚠️  File not found: #{full_path}"
    next
  end
  
  # Create or get the group
  unless groups[group_name]
    groups[group_name] = main_group.new_group(group_name, group_name)
  end
  group = groups[group_name]
  
  # Add file to the group
  ref = group.new_file(full_path)
  
  # Add to appropriate build phase
  if file_path.end_with?('.m')
    sources_phase.add_file_reference(ref)
    puts "✅ Added source: #{file_path}"
  elsif file_path.end_with?('.h')
    headers_phase.add_file_reference(ref)
    puts "✅ Added header: #{file_path}"
  elsif file_path.end_with?('.swift')
    sources_phase.add_file_reference(ref)
    puts "✅ Added Swift: #{file_path}"
  end
end

# Update target settings
target.build_configurations.each do |config|
  config.build_settings['HEADER_SEARCH_PATHS'] = '$(SRCROOT)/Sources/JailbreakShieldCore/include'
  config.build_settings['PUBLIC_HEADER_SEARCH_PATHS'] = '$(SRCROOT)/Sources/JailbreakShieldCore/include'
end

project.save
puts "✨ Project file updated successfully!"

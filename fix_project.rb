require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)

target = project.targets.first
main_group = project.main_group['JailbreakShield'] || project.main_group

# Remove ALL existing file references (clean slate)
main_group.recursive_children_groups.each(&:clear)
main_group.files.each(&:remove_from_project)

# File groups: GroupName => { folder => [files] }
structure = {
  'Detection' => {
    'Detection' => ['HDJailbreakDetection.h', 'HDJailbreakDetection.m']
  },
  'SecurityUI' => {
    'SecurityUI' => ['HDSecurityBlockViewController.h', 'HDSecurityBlockViewController.m',
                     'HDSecurityBlockWindow.h', 'HDSecurityBlockWindow.m']
  },
  'ScreenProtection' => {
    'ScreenProtection' => ['ScreenProtectionManager.h', 'ScreenProtectionManager.m']
  },
  'Swift' => {
    'Swift' => ['JailbreakShieldNew.swift']
  }
}

# Clear compile sources and headers build phases
sources_phase = target.source_build_phase
headers_phase = target.headers_build_phase
sources_phase.files_references.each { |f| sources_phase.remove_file_reference(f) rescue nil }

structure.each do |group_name, folder_map|
  folder_map.each do |folder, files|
    group = main_group[group_name] || main_group.new_group(group_name, folder)
    files.each do |filename|
      full_path = File.expand_path("~/Desktop/JailbreakShield/#{folder}/#{filename}")
      unless File.exist?(full_path)
        puts "⚠️  Missing: #{full_path}"
        next
      end
      ref = group.new_file(full_path)
      if filename.end_with?('.m')
        sources_phase.add_file_reference(ref)
        puts "✅ Added source: #{filename}"
      elsif filename.end_with?('.h')
        headers_phase.add_file_reference(ref) rescue nil
        puts "✅ Added header: #{filename}"
      elsif filename.end_with?('.swift')
        sources_phase.add_file_reference(ref)
        puts "✅ Added swift: #{filename}"
      end
    end
  end
end

project.save
puts "\n✅ Done! Reopen Xcode now."

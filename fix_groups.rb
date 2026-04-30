require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)

# Remove path from all subgroups so they become virtual groups
['Detection', 'SecurityUI', 'ScreenProtection', 'Swift'].each do |name|
  project.main_group.recursive_children_groups.each do |grp|
    if grp.name == name || grp.path == name
      grp.path = nil
      grp.source_tree = '<group>'
      puts "✅ Removed disk path from group: #{name}"
    end
  end
end

project.save
puts "\n✅ Groups are now virtual (no disk path)."

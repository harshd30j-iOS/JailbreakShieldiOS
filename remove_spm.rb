require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)

target = project.targets.first

# Remove Sources/JailbreakShield/JailbreakShield.swift from compile sources
target.source_build_phase.files.each do |f|
  path = f.file_ref&.path.to_s
  if path.include?('Sources') || path.include?('JailbreakShield.swift')
    puts "Removing from sources: #{path}"
    f.remove_from_project
  end
end

# Remove the file reference entirely
project.files.each do |ref|
  path = ref.path.to_s
  if path.include?('Sources') || (path == 'JailbreakShield.swift')
    puts "Removing file ref: #{path}"
    ref.remove_from_project
  end
end

project.save
puts "✅ Done."

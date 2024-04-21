files_to_exclude = [__FILE__, 'command_center.rb']

Dir.glob('app/*.rb').each do |file|
  next if files_to_exclude.include?(File.basename(file))

  require_relative File.basename(file)
end

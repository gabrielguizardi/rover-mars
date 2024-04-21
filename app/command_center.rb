require_relative 'load_files'

input_path = File.join(__dir__, '../data/input.txt')
input_content = File.read(input_path)
input_lines = input_content.lines.map(&:chomp)

input = Input.new(input_lines)

plateau_dimensions = input.plateau_dimensions
plateau = Plateau.new(plateau_dimensions[:width], plateau_dimensions[:height])

rovers_info = input.rovers_info

rovers = rovers_info.map do |rover_info|
  rover = Rover.new(
    rover_info[:location][:x],
    rover_info[:location][:y],
    rover_info[:location][:cardinal_point],
    plateau
  )

  rover_info[:instructions].each do |instruction|
    rover.execute_instruction(instruction)
  end

  rover
end

output_path = File.join(__dir__, '../data/output.txt')
File.open(output_path, 'w') do |file|
  rovers.each do |rover|
    file.puts "#{rover.x} #{rover.y} #{rover.cardinal_point}"
  end
end

puts "Final rover(s) position(s): #{plateau.occupied_positions.inspect}"

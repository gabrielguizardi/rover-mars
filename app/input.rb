class Input
  attr_reader :input_lines

  def initialize(input_lines)
    @input_lines = input_lines

    validate_number_of_lines!
  end

  def plateau_dimensions
    validate_plateau_dimensions!
    dimensions = input_lines.first.split.map(&:to_i)

    {
      width: dimensions[0],
      height: dimensions[1]
    }
  end

  def rovers_info
    input_lines[1..].each_slice(2).map do |rover_info|
      validate_rover_info!(rover_info)

      position = rover_info.first.split
      instructions = rover_info.last.split('')

      {
        location: {
          x: position[0].to_i,
          y: position[1].to_i,
          cardinal_point: position[2]
        },
        instructions: instructions
      }
    end
  end

  private

  def validate_number_of_lines!
    return if input_lines.size >= 3

    raise ArgumentError, 'Input must have at least 3 lines.'
  end

  def validate_plateau_dimensions!
    plateau_dimensions = input_lines.first.split.map(&:to_i)

    return if plateau_dimensions.size == 2

    raise ArgumentError, 'Plateau dimensions must be two integers.'
  end

  def validate_rover_info!(rover_info)
    validate_rover_size!(rover_info)
    validate_rover_position!(rover_info.first.split)
    validate_rover_instructions!(rover_info.last.split(''))
  end

  def validate_rover_size!(rover_info)
    return if rover_info.size == 2

    raise ArgumentError, 'Rover info must have 2 lines.'
  end

  def validate_rover_position!(position)
    return if position.size == 3 && integers?(position[0..1]) && cardinal_cardinal_point?(position[2])

    raise ArgumentError, 'Rover position must be two integers and a cardinal letter.'
  end

  def integers?(array)
    array.all? { |i| i.match?(/\A-?\d+\Z/) }
  end

  def cardinal_cardinal_point?(cardinal_point)
    cardinal_point.match?(/\A[NESW]\Z/)
  end

  def validate_rover_instructions!(instructions)
    return if instructions.all? { |i| i.match?(/\A[LRM]\Z/) }

    raise ArgumentError, 'Rover instructions must be a series of L, R, and M.'
  end
end

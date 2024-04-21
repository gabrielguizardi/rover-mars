class Plateau
  attr_accessor :width, :height, :occupied_positions

  def initialize(width, height)
    validate_dimensions!(width, height)

    @width = width
    @height = height
    @occupied_positions = []
  end

  def occupy_initial_position!(x, y)
    validate_position!(x, y)
    @occupied_positions << [x, y]
    occupied_positions.size - 1
  end

  def update_position!(index, x, y)
    validate_position!(x, y)
    @occupied_positions[index] = [x, y]
  end

  private

  def validate_dimensions!(width, height)
    return if width >= 0 && height >=  0

    raise ArgumentError, 'Invalid plateau dimensions: width and height must be non-negative.'
  end

  def validate_position!(x, y)
    return if position_within_bounds?(x, y) && !position_occupied?(x, y)

    raise ArgumentError, 'Position invalid, please choose another one.'
  end

  def position_within_bounds?(x, y)
    (0..@width).include?(x) && (0..@height).include?(y)
  end

  def position_occupied?(x, y)
    @occupied_positions.include?([x, y])
  end
end

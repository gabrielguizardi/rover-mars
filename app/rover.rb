class Rover
  attr_reader :x, :y, :cardinal_point, :plateau, :rover_plateau_index

  DIRECTIONS = {
    'N' => [0, 1],
    'E' => [1, 0],
    'S' => [0, -1],
    'W' => [-1, 0]
  }.freeze
  CARDINAL_POINTS = DIRECTIONS.keys.freeze

  def initialize(x, y, cardinal_point, plateau)
    @x = x
    @y = y
    @cardinal_point = cardinal_point
    @plateau = plateau
    @rover_plateau_index = plateau.occupy_initial_position!(x, y)
  end

  def execute_instruction(instruction)
    case instruction
    when 'L'
      turn_left
    when 'R'
      turn_right
    when 'M'
      move_forward
    else
      raise ArgumentError, "Invalid instruction: #{instruction}"
    end
  end

  private

  def turn_left
    @cardinal_point = CARDINAL_POINTS[cardinal_point_index - 1]
  end

  def turn_right
    @cardinal_point = CARDINAL_POINTS[cardinal_point_index + 1] || CARDINAL_POINTS.first
  end

  def move_forward
    dx, dy = DIRECTIONS[cardinal_point]

    new_x = x + dx
    new_y = y + dy

    plateau.update_position!(rover_plateau_index, new_x, new_y)

    @x = new_x
    @y = new_y

    [x, y]
  end

  def cardinal_point_index
    CARDINAL_POINTS.index(@cardinal_point)
  end
end

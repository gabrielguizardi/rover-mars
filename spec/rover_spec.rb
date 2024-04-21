require_relative '../app/rover'
require_relative '../app/plateau'

RSpec.describe Rover do
  attr_reader :plateau

  before do
    @plateau = Plateau.new(5, 5)
  end

  it 'has the correct constants defined' do
    expect(described_class.const_defined?(:DIRECTIONS)).to eq(true)
    expect(described_class.const_defined?(:CARDINAL_POINTS)).to eq(true)
  end

  describe '#initialize' do
    context 'when position is invalid' do
      before do
        allow(plateau).to receive(:occupy_initial_position!).with(4, 5).and_raise(ArgumentError)
      end

      it 'should raise an ArgumentError' do
        expect { described_class.new(4, 5, 'N', plateau) }.to raise_error(ArgumentError)
      end
    end

    context 'when position is valid' do
      before do
        @instance = described_class.new(4, 5, 'N', plateau)
      end

      it 'should set the x attribute' do
        expect(@instance.x).to eq(4)
      end

      it 'should set the y attribute' do
        expect(@instance.y).to eq(5)
      end

      it 'should set the cardinal_point attribute' do
        expect(@instance.cardinal_point).to eq('N')
      end

      it 'should set the plateau attribute' do
        expect(@instance.plateau).to eq(plateau)
      end

      it 'should set the rover_plateau_index attribute' do
        expect(@instance.rover_plateau_index).to eq(plateau.occupied_positions.size - 1)
      end
    end
  end

  describe '#execute_instruction' do
    before do
      @instance = described_class.new(2, 2, 'N', plateau)
    end

    context 'when instruction is invalid' do
      it 'should raise an ArgumentError' do
        expect { @instance.execute_instruction('X') }.to raise_error(ArgumentError, 'Invalid instruction: X')
      end
    end

    context 'when instruction is valid' do
      context 'when instruction is L' do
        after do
          @instance.execute_instruction('L')
        end

        it 'should call turn_left' do
          expect(@instance).to receive(:turn_left).once
        end

        it 'should not call turn_right' do
          expect(@instance).not_to receive(:turn_right)
        end

        it 'should not call move_forward' do
          expect(@instance).not_to receive(:move_forward)
        end
      end

      context 'when instruction is R' do
        after do
          @instance.execute_instruction('R')
        end

        it 'should not call turn_left' do
          expect(@instance).not_to receive(:turn_left)
        end

        it 'should call turn_right' do
          expect(@instance).to receive(:turn_right).once
        end

        it 'should not call move_forward' do
          expect(@instance).not_to receive(:move_forward)
        end
      end

      context 'when instruction is M' do
        after do
          @instance.execute_instruction('M')
        end

        it 'should not call turn_left' do
          expect(@instance).not_to receive(:turn_left)
        end

        it 'should not call turn_right' do
          expect(@instance).not_to receive(:turn_right)
        end

        it 'should call move_forward' do
          expect(@instance).to receive(:move_forward)
        end
      end
    end
  end

  describe '#turn_left' do
    context 'when cardinal_point is N' do
      before do
        @instance = described_class.new(2, 2, 'N', plateau)
        @instance.send(:turn_left)
      end

      it 'should set the cardinal_point attribute to W' do
        expect(@instance.cardinal_point).to eq('W')
      end
    end

    context 'when cardinal_point is W' do
      before do
        @instance = described_class.new(2, 2, 'W', plateau)
        @instance.send(:turn_left)
      end

      it 'should set the cardinal_point attribute to S' do
        expect(@instance.cardinal_point).to eq('S')
      end
    end

    context 'when cardinal_point is S' do
      before do
        @instance = described_class.new(2, 2, 'S', plateau)
        @instance.send(:turn_left)
      end

      it 'should set the cardinal_point attribute to E' do
        expect(@instance.cardinal_point).to eq('E')
      end
    end

    context 'when cardinal_point is E' do
      before do
        @instance = described_class.new(2, 2, 'E', plateau)
        @instance.send(:turn_left)
      end

      it 'should set the cardinal_point attribute to N' do
        expect(@instance.cardinal_point).to eq('N')
      end
    end
  end

  describe '#turn_right' do
    context 'when cardinal_point is N' do
      before do
        @instance = described_class.new(2, 2, 'N', plateau)
        @instance.send(:turn_right)
      end

      it 'should set the cardinal_point attribute to E' do
        expect(@instance.cardinal_point).to eq('E')
      end
    end

    context 'when cardinal_point is E' do
      before do
        @instance = described_class.new(2, 2, 'E', plateau)
        @instance.send(:turn_right)
      end

      it 'should set the cardinal_point attribute to S' do
        expect(@instance.cardinal_point).to eq('S')
      end
    end

    context 'when cardinal_point is S' do
      before do
        @instance = described_class.new(2, 2, 'S', plateau)
        @instance.send(:turn_right)
      end

      it 'should set the cardinal_point attribute to W' do
        expect(@instance.cardinal_point).to eq('W')
      end
    end

    context 'when cardinal_point is W' do
      before do
        @instance = described_class.new(2, 2, 'W', plateau)
        @instance.send(:turn_right)
      end

      it 'should set the cardinal_point attribute to N' do
        expect(@instance.cardinal_point).to eq('N')
      end
    end
  end

  describe '#move_forward' do
    context 'when next position is invalid' do
      before do
        allow(plateau).to receive(:update_position!).and_raise(ArgumentError)

        @instance = described_class.new(5, 5, 'N', plateau)
      end

      it 'should raise an ArgumentError' do
        expect { @instance.send(:move_forward) }.to raise_error(ArgumentError)
      end
    end

    context 'when next position is valid' do
      context 'when cardinal_point is N' do
        before do
          @instance = described_class.new(2, 2, 'N', plateau)
          @instance.send(:move_forward)
        end

        it 'should set the x attribute to 2' do
          expect(@instance.x).to eq(2)
        end

        it 'should set the y attribute to 3' do
          expect(@instance.y).to eq(3)
        end
      end

      context 'when cardinal_point is E' do
        before do
          @instance = described_class.new(2, 2, 'E', plateau)
          @instance.send(:move_forward)
        end

        it 'should set the x attribute to 3' do
          expect(@instance.x).to eq(3)
        end

        it 'should set the y attribute to 2' do
          expect(@instance.y).to eq(2)
        end
      end

      context 'when cardinal_point is S' do
        before do
          @instance = described_class.new(2, 2, 'S', plateau)
          @instance.send(:move_forward)
        end

        it 'should set the x attribute to 2' do
          expect(@instance.x).to eq(2)
        end

        it 'should set the y attribute to 1' do
          expect(@instance.y).to eq(1)
        end
      end

      context 'when cardinal_point is W' do
        before do
          @instance = described_class.new(2, 2, 'W', plateau)
          @instance.send(:move_forward)
        end

        it 'should set the x attribute to 1' do
          expect(@instance.x).to eq(1)
        end

        it 'should set the y attribute to 2' do
          expect(@instance.y).to eq(2)
        end
      end
    end
  end

  describe '#cardinal_point_index' do
    context 'when cardinal_point is N' do
      before do
        @instance = described_class.new(2, 2, 'N', plateau)
      end

      it 'should return 0' do
        expect(@instance.send(:cardinal_point_index)).to eq(0)
      end
    end

    context 'when cardinal_point is E' do
      before do
        @instance = described_class.new(2, 2, 'E', plateau)
      end

      it 'should return 1' do
        expect(@instance.send(:cardinal_point_index)).to eq(1)
      end
    end

    context 'when cardinal_point is S' do
      before do
        @instance = described_class.new(2, 2, 'S', plateau)
      end

      it 'should return 2' do
        expect(@instance.send(:cardinal_point_index)).to eq(2)
      end
    end

    context 'when cardinal_point is W' do
      before do
        @instance = described_class.new(2, 2, 'W', plateau)
      end

      it 'should return 3' do
        expect(@instance.send(:cardinal_point_index)).to eq(3)
      end
    end
  end
end

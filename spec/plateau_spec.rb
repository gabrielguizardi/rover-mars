require_relative '../app/plateau'

RSpec.describe Plateau do
  describe '#initialize' do
    context 'when dimensions are valid' do
      before do
        @instance = described_class.new(5, 6)
      end

      it 'should set the width attribute' do
        expect(@instance.width).to eq(5)
      end

      it 'should set the height attribute' do
        expect(@instance.height).to eq(6)
      end

      it 'should set the width attribute' do
        expect(@instance.occupied_positions).to be_empty
      end
    end

    context 'when dimensions are invalid' do
      it 'should raise an ArgumentError' do
        expect { described_class.new(-1, 1) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#occupy_initial_position!' do
    before do
      @instance = described_class.new(5, 5)
    end

    context 'when position is invalid' do
      before do
        allow(@instance).to receive(:validate_position!).and_raise(ArgumentError)
      end

      it 'should raise an ArgumentError' do
        expect { @instance.occupy_initial_position!(2, 1) }.to raise_error(ArgumentError)
      end
    end

    context 'when position is valid' do
      before do
        @response = @instance.occupy_initial_position!(2, 1)
      end

      it 'should add the position to the occupied_positions attribute' do
        expect(@response).to eq(@instance.occupied_positions.size - 1)
        expect(@instance.occupied_positions).to include([2, 1])
      end
    end
  end

  describe '#update_position!' do
    before do
      @instance = described_class.new(5, 5)
      @instance.occupy_initial_position!(2, 1)
    end

    context 'when position is invalid' do
      before do
        allow(@instance).to receive(:validate_position!).and_raise(ArgumentError)
      end

      it 'should raise an ArgumentError' do
        expect { @instance.update_position!(0, 2, 1) }.to raise_error(ArgumentError)
      end
    end

    context 'when position is valid' do
      before do
        @instance.update_position!(0, 3, 4)
      end

      it 'should update the position in the occupied_positions attribute' do
        expect(@instance.occupied_positions[0]).to match_array([3, 4])
      end
    end
  end

  describe '#validate_dimensions!' do
    before do
      @instance = described_class.new(5, 5)
    end

    context 'when dimensions are invalid' do
      context 'when width is invalid' do
        it 'should raise an ArgumentError' do
          expect { @instance.send(:validate_dimensions!, -1, 5) }.to raise_error(ArgumentError, 'Invalid plateau dimensions: width and height must be non-negative.')
        end
      end

      context 'when height is invalid' do
        it 'should raise an ArgumentError' do
          expect { @instance.send(:validate_dimensions!, 5, -1) }.to raise_error(ArgumentError, 'Invalid plateau dimensions: width and height must be non-negative.')
        end
      end
    end

    context 'when dimensions are valid' do
      it 'should not raise error' do
        expect { @instance.send(:validate_dimensions!, 5, 5) }.not_to raise_error
      end
    end
  end

  describe '#validate_position!' do
    before do
      @instance = described_class.new(5, 5)
    end

    context 'when position is invalid' do
      context 'when position is out of bounds' do
        before do
          allow(@instance).to receive(:position_within_bounds?).with(5, 1).and_return(false)
        end

        it 'should raise an ArgumentError' do
          expect { @instance.send(:validate_position!, 5, 1) }.to raise_error(ArgumentError, 'Position invalid, please choose another one.')
        end
      end

      context 'when position is occupied' do
        before do
          allow(@instance).to receive(:position_within_bounds?).with(5, 1).and_return(true)
          allow(@instance).to receive(:position_occupied?).with(5, 1).and_return(true)
        end

        it 'should raise an ArgumentError' do
          expect { @instance.send(:validate_position!, 5, 1) }.to raise_error(ArgumentError, 'Position invalid, please choose another one.')
        end
      end
    end

    context 'when position is valid' do
      it 'should not raise error' do
        expect { @instance.send(:validate_position!, 3, 4) }.not_to raise_error
      end
    end
  end

  describe '#position_within_bounds?' do
    before do
      @instance = described_class.new(5, 5)
    end

    context 'when position is out of bounds' do
      context 'when x is out of bounds' do
        it 'should return false' do
          expect(@instance.send(:position_within_bounds?, 6, 1)).to be false
        end
      end

      context 'when y is out of bounds' do
        it 'should return false' do
          expect(@instance.send(:position_within_bounds?, 1, 6)).to be false
        end
      end
    end

    context 'when position is within bounds' do
      it 'should return true' do
        expect(@instance.send(:position_within_bounds?, 5, 1)).to be true
      end
    end
  end

  describe '#position_occupied?' do
    before do
      @instance = described_class.new(5, 5)
      @instance.occupy_initial_position!(2, 1)
    end

    context 'when position is occupied' do
      it 'should return true' do
        expect(@instance.send(:position_occupied?, 2, 1)).to be true
      end
    end

    context 'when position is not occupied' do
      it 'should return false' do
        expect(@instance.send(:position_occupied?, 1, 1)).to be false
      end
    end
  end
end

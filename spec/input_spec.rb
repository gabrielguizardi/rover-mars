require_relative '../app/input'

RSpec.describe Input do
  let(:valid_input_lines) do
    [
      '5 5',
      '1 2 N',
      'LMLMLMLMM',
      '3 3 E',
      'MMRMMRMRRM'
    ]
  end

  describe '#initialize' do
    context 'when input_lines is invalid' do
      it 'should raise an ArgumentError' do
        expect { described_class.new([]) }.to raise_error(ArgumentError)
      end
    end

    context 'when input_lines is valid' do
      before do
        @instance = described_class.new(valid_input_lines)
      end

      it 'should set the input_lines attribute' do
        expect(@instance.input_lines).to eq(valid_input_lines)
      end
    end
  end

  describe '#plateau_dimensions' do
    context 'when plateau dimensions is invalid' do
      before do
        @instance = described_class.new(valid_input_lines)
        allow(@instance).to receive(:validate_plateau_dimensions!).and_raise(ArgumentError)
      end

      it 'should raise an ArgumentError' do
        expect { @instance.plateau_dimensions }.to raise_error(ArgumentError)
      end
    end

    context 'when plateau dimensions is valid' do
      before do
        @instance = described_class.new(valid_input_lines)
      end

      it 'should return the plateau dimensions' do
        expect(@instance.plateau_dimensions).to eq(width: 5, height: 5)
      end
    end
  end

  describe '#rovers_info' do
    context 'when rover info is invalid' do
      before do
        @instance = described_class.new(valid_input_lines)
        allow(@instance).to receive(:validate_rover_info!).and_raise(ArgumentError)
      end

      it 'should raise an ArgumentError' do
        expect { @instance.rovers_info }.to raise_error(ArgumentError)
      end
    end

    context 'when rover info is valid' do
      before do
        @instance = described_class.new(valid_input_lines)
      end

      it 'should return the rovers info' do
        expect(@instance.rovers_info).to match_array([
          {
            location: { x: 1, y: 2, cardinal_point: 'N' },
            instructions: %w[L M L M L M L M M]
          },
          {
            location: { x: 3, y: 3, cardinal_point: 'E' },
            instructions: %w[M M R M M R M R R M]
          }
        ])
      end
    end
  end

  describe '#validate_number_of_lines!' do
    context 'when input has less than 3 lines' do
      it 'should raise an ArgumentError' do
        expect { described_class.new(['5 5']) }.to raise_error(ArgumentError, 'Input must have at least 3 lines.')
        expect { described_class.new(['5 5', '1 3 N']) }.to raise_error(ArgumentError, 'Input must have at least 3 lines.')
      end
    end

    context 'when input has exactly 3 lines' do
      it 'should not raise error' do
        expect { described_class.new(['5 5', '1 2 N', 'LMLMLMLMM']) }.not_to raise_error
      end
    end

    context 'when input has more than 3 lines' do
      it 'should not raise error' do
        expect { described_class.new(valid_input_lines) }.not_to raise_error
      end
    end
  end

  describe '#validate_plateau_dimensions!' do
    context 'when the plateau dimensions arent exactly two integers' do
      it 'should raise an ArgumentError' do
        expect { described_class.new(['5', '', '']).send(:validate_plateau_dimensions!) }.to raise_error(ArgumentError, 'Plateau dimensions must be two integers.')
        expect { described_class.new(['5 5 5', '', '']).send(:validate_plateau_dimensions!) }.to raise_error(ArgumentError, 'Plateau dimensions must be two integers.')
      end
    end

    context 'when the plateau dimensions are exactly two integers' do
      it 'should not raise error' do
        expect { described_class.new(valid_input_lines) }.not_to raise_error
      end
    end
  end

  describe '#validate_rover_info!' do
    before do
      @rover_info = ['1 2 N', 'LMLMLMLMM']
      @instance = described_class.new(valid_input_lines)
    end

    after do
      @instance.send(:validate_rover_info!, @rover_info)
    end

    it 'should call validate_rover_size!' do
      expect(@instance).to receive(:validate_rover_size!).with(@rover_info)
    end

    it 'should call validate_rover_position!' do
      expect(@instance).to receive(:validate_rover_position!).with(@rover_info.first.split)
    end

    it 'should call validate_rover_instructions!' do
      expect(@instance).to receive(:validate_rover_instructions!).with(@rover_info.last.split(''))
    end
  end

  describe '#validate_rover_size!' do
    before do
      @instance = described_class.new(valid_input_lines)
    end

    context 'when rover info does not have 2 lines' do
      it 'should raise an ArgumentError' do
        expect { @instance.send(:validate_rover_size!, ['1 2 N']) }.to raise_error(ArgumentError, 'Rover info must have 2 lines.')
      end
    end

    context 'when rover info has 2 lines' do
      it 'should not raise error' do
        expect { @instance.send(:validate_rover_size!, ['1 2 N', 'LMLMLMLMM']) }.not_to raise_error
      end
    end
  end

  describe '#validate_rover_position!' do
    let(:error_message) { 'Rover position must be two integers and a cardinal letter.' }

    before do
      @instance = described_class.new(valid_input_lines)
    end

    context 'when rover position is invalid' do
      context 'when rover position does not have 3 elements' do
        it 'should raise an ArgumentError' do
          expect { @instance.send(:validate_rover_position!, ['1 2']) }.to raise_error(ArgumentError, error_message)
        end
      end

      context 'when rover position x is not an integer' do
        it 'should raise an ArgumentError' do
          expect { @instance.send(:validate_rover_position!, ['a', '2', 'N']) }.to raise_error(ArgumentError, error_message)
        end
      end

      context 'when rover position y is not an integer' do
        it 'should raise an ArgumentError' do
          expect { @instance.send(:validate_rover_position!, ['1', 'b', 'N']) }.to raise_error(ArgumentError, error_message)
        end
      end

      context 'when rover position cardinal point is not valid' do
        it 'should raise an ArgumentError' do
          expect { @instance.send(:validate_rover_position!, ['1', '2', 'Z']) }.to raise_error(ArgumentError, error_message)
        end
      end
    end

    context 'when rover position is valid' do
      it 'should not raise error' do
        expect { @instance.send(:validate_rover_position!, ['1', '2', 'N']) }.not_to raise_error
      end
    end
  end

  describe '#validate_rover_instructions!' do
    before do
      @instance = described_class.new(valid_input_lines)
    end

    context 'when rover instructions are invalid' do
      it 'should raise an ArgumentError' do
        expect { @instance.send(:validate_rover_instructions!, ['L', 'M', 'R', 'Z']) }.to raise_error(ArgumentError,'Rover instructions must be a series of L, R, and M.')
      end
    end

    context 'when rover instructions are valid' do
      it 'should not raise error' do
        expect { @instance.send(:validate_rover_instructions!, ['L', 'M', 'R', 'M']) }.not_to raise_error
      end
    end
  end
end

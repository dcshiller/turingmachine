class MachineState
  attr_reader :state_array
	attr_accessor :number, :instruction_hash

  def initialize(state_number)
		@number = state_number
		@instruction_hash = {}
	end

  def self.connected(state)
    [state.instruction_hash[:x][1], state.instruction_hash[:"0"][1]]
  end

  def self.get_downstream_states(state, states = [])
    connected_states = MachineState.connected(state)
    return states if connected_states.all? {|state| states.include?(state)}
    states += connected_states
    states = states.uniq
    connected_states.each {|state| states += MachineState.get_downstream_states(state, states)}
    states.uniq.sort {|a,b| a.number <=> b.number}
  end

  def self.halt(state_number)
		halt_state = MachineState.new(state_number)
		halt_state.set_behavior(:x =>[:halt, halt_state], :"0" => [:halt, halt_state])
		halt_state
	end

	def self.make_simple_program
		first = MachineState.new(1)
		second = MachineState.new(2)
		third = MachineState.new(3)
		first.set_behavior({:x => [:mark0,first], :"0" => [:right,second]})
		second.set_behavior({:x => [:left,third], :"0" => [:markx, second]})
		third.set_behavior({:x => [:halt,third], :"0" => [:right, first]})
		first
	end

  def self.make_adder
    first = MachineState.new(1)
    second = MachineState.new(2)
    third = MachineState.new(3)
    fourth = MachineState.new(4)
    fifth = MachineState.new(5)
    sixth = MachineState.new(6)
    last = MachineState.halt(7)
    first.set_behavior({:x => [:mark0,second], :"0" => [:right,last]})
    second.set_behavior({:x => [:right,second], :"0" => [:right,third]})
    third.set_behavior({:x => [:right,third], :"0" => [:right,fourth]})
    fourth.set_behavior({:x => [:right,fourth], :"0" => [:markx, fifth]})
    fifth.set_behavior({:x => [:left,fifth], :"0" => [:left,sixth]})
    sixth.set_behavior({:x => [:left,sixth], :"0" => [:right,first]})
    first
  end

  def count
    MachineState.get_downstream_states(self).count
  end

	def get_behavior(input)
		@instruction_hash[input].first
	end

  def get_behavior_as_string(input)
    case get_behavior(input)
    when :mark0
      "write a 0"
    when :markx
      "write a x"
    when :right
      "move to the right"
    when :left
      "move to the left"
    when :halt
      "halt"
    end
  end

	def get_next_state(input)
		@instruction_hash[input].last
	end

  def get_state_information(state_number)
    MachineState.get_downstream_states(self)[state_number].to_s
  end

  def get_state_information_hash
    {
      "state_number" => number_tag,
      "input_x_behavior" => get_behavior(:x).to_s,
      "input_x_state" => get_next_state(:x).number_tag,
      "input_o_behavior" => get_behavior(:"0").to_s,
      "input_o_state" => get_next_state(:"0").number_tag
    }
  end

  def number_tag
    ones_digits = ["","One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
                  "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen",
                  "Nineteen"]
    tens_digits = ["","","Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"]
    return ones_digits[number] if number < 20
    tens_digits[(number/10)] + ones_digits[(number % 10)]
  end

  def to_s
		number.to_s + ":   (" + instruction_hash.collect {|key, value| key.to_s + "=>" + value.first.to_s + " " + value.last.number.to_s}.join(", ") + ")"
	end

	def set_behavior(behavior_hash)
		default = behavior_hash.default
		@instruction_hash = @instruction_hash.merge(behavior_hash)
		@instruction_hash.default = default
	end
end

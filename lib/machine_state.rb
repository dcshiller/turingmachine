
class MachineState
  attr_reader :state_array
	attr_accessor :number, :instruction_hash

  def self.get_downstream_states(state, states = [])
    connected_states = MachineState.connected(state)
    return states if connected_states.all? {|state| states.include?(state)}
    states += connected_states
    states.uniq!
    connected_states.each {|state| MachineState.get_downstream_states(state, states)}
  end

  def self.connected(state)
    [state.instruction_hash[:x][1],state.instruction_hash[:0][1]]
  end

	def initialize(state_number)
		@number = state_number
		@instruction_hash = {}
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
    @state_array += [first,second,third,fourth,fifth,sixth,last]
		first.set_behavior({:x => [:mark0,second], :"0" => [:right,last]})
		second.set_behavior({:x => [:right,second], :"0" => [:right,third]})
		third.set_behavior({:x => [:right,third], :"0" => [:right,fourth]})
		fourth.set_behavior({:x => [:right,fourth], :"0" => [:markx, fifth]})
		fifth.set_behavior({:x => [:left,fifth], :"0" => [:left,sixth]})
		sixth.set_behavior({:x => [:left,sixth], :"0" => [:right,first]})
		#sevent.set_behavior({:x => [:right,sixth], :"0" => [:right,first]})
		first
	end

	def to_s
		number.to_s + ":   (" + instruction_hash.collect {|key, value| key.to_s + "=>" + value.first.to_s + " " + value.last.number.to_s}.join(", ") + ")"
	end

	def self.halt(state_number = 0)
		halt_state = MachineState.new(state_number)
		halt_state.number = state_number
		halt_state.set_behavior(Hash.new([:halt, halt_state.number]))
		halt_state
	end

	def set_behavior(behavior_hash)
		default = behavior_hash.default
		@instruction_hash = @instruction_hash.merge(behavior_hash)
		@instruction_hash.default = default
	end

	def get_behavior(input)
		@instruction_hash[input].first
	end

	def get_next_state(input)
		@instruction_hash[input].last
	end
end

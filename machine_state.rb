
class MachineState
	attr_accessor :number, :instruction_hash

	def initialize(state_number)
		@number = state_number
		@instruction_hash = {}
	end

	def self.halt(state_number = 0)
		halt_state = MachineState.new(state_number)
		halt_state.number = state_number
		halt_state.set_behavior({:x => :halt, :"0" => :halt})
	end

	def set_behavior(behavior_hash)
		instruction_hash.merge(behavior_hash)
	end

	def get_behavior(input)
		instruction_hash[input]
	end


end


class MachineState

	attr_accessor :number, :instruction_hash

	def initialize(state_number)
		number = state_number		
	end

	def set_behavior(input, behavior)
		instruction_hash[input] = behavior
	end

	def get_behavior(input)
		instruction_hash[input]
	end

end



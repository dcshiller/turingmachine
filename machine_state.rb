
class MachineState

	attr_accessor :number, :instruction_hash

	def initialize(state_number)
		number = state_number		
	end

	def set_behavior(behavior_hash)
		instruction_hash.merge(behavior_hash)
	end

	def get_behavior(input)
		instruction_hash[input]
	end

end



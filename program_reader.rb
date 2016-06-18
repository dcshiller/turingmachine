
load 'machines_state.rb'


class ProgramReader


	def initialize
		@counter = 0
	end

	def counter
		@counter += 1
	end


	def define_program
		adder = MachineState.new(counter)
		adder.set_behavior({:1=>[:L,1] , :0=>[:x,0]})
	end


	def start 

	end
end

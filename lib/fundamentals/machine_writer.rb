require 'yaml'

module MachineWriter

  def load_program
    begin
      files = Dir["./programs/*.tm"]
      files.collect! {|filename| filename.split("/").last.split(".").first}
      files.unshift("")
      files.unshift("Files:")
      files << ""
      response = full_screen_gets('File name:', files ).chomp
      unless response == 'back'
        file_name = './programs/' + response +'.tm'
        yaml_program_states = File.read(file_name)
        $program = YAML.load(yaml_program_states).first
      end
    rescue
      flash("file not found \n" + center("('back'returns to menu)"))
      retry
    end
  end
  
  def read_program(file)
    unyamlized_prog = YAML::load(File.read(file))
  end

  def write_program(program, file)
    yamlized_prog = program.to_yaml
    File.write(file, yamlized_prog)
  end
end

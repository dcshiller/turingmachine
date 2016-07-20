require 'yaml'

module MachineWriter

  def write_program(program, file)
    yamlized_prog = program.to_yaml
    File.write(file, yamlized_prog)
  end

  def read_program(file)
    unyamlized_prog = YAML::load(File.read(file))
  end

end

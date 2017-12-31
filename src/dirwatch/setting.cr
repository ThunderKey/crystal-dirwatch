require "yaml"

# This represents a specific setting for a dirwatch task.
class Dirwatch::Setting
  # Global defaults that are used if they are not specified.
  GLOBAL_DEFAULTS = {
    "directory" => ".",
    "interval" => 1,
  }

  # Read the configuration of the given filename (YAML) and return a list of all Setting
  #
  # Example of a file:
  # ```yaml
  # defaults:
  #   interval: 1
  #
  # my-task-1:
  #   file_match: "*.txt"
  #   script: "echo file changed >> txt.log"
  #
  # my-task-2:
  #   directory: folder/to/csv/files
  #   file_match: "*.csv"
  #   script:
  #     - "echo CSV >> csv.log"
  #     - "echo file changed >> csv.log"
  # ```
  #
  # Which will return an array like:
  # ```
  # [
  #   #<Dirwatch::Setting
  #     @key="my-task-1",
  #     @directory=".",
  #     @file_match="*.txt",
  #     @interval=2.0,
  #     @scripts=["echo file changed >> txt.log"]
  #   >,
  #   #<Dirwatch::Setting
  #     @key="my-task-2",
  #     @directory="folder/to/csv/files",
  #     @file_match="*.csv",
  #     @interval=2.0,
  #     @scripts=["echo CSV >> csv.log", "echo file changed >> csv.log"]
  #   >
  # ]
  # ```
  def self.from_file(filename)
    yaml = YAML.parse File.read(filename)
    defaults = yaml["defaults"]?
    defaults = GLOBAL_DEFAULTS.merge(defaults ? defaults.as_h : {} of YAML::Type => YAML::Type)

    settings = [] of Setting
    yaml.each do |k, d|
      next if k == "defaults"
      data = defaults.merge d.as_h
      settings << new(
        k.as_s,
        to_string(data["directory"]?, "directory"),
        to_string(data["file_match"]?, "directory"),
        to_int(data["interval"]?, "interval"),
        to_string_array(data["script"]?, "scripts"),
      )
    end
    settings
  end

  private def self.to_string(value : YAML::Type | Int32, key)
    return value if value.is_a? String
    raise UserFriendlyException.new "Required setting #{key.inspect} is missing" if value.nil?
    raise UserFriendlyException.new "The setting #{key.inspect} must be a string and not #{value.inspect}"
  end

  private def self.to_string_array(value : YAML::Type | Int32, key)
    return [value] if value.is_a? String
    if value.is_a? Array
      return value.map {|v| to_string v, key }
    end
    raise UserFriendlyException.new "Required setting #{key.inspect} is missing" if value.nil?
    raise UserFriendlyException.new "The setting #{key.inspect} must be a string or array and not #{value.inspect}"
  end

  private def self.to_int(value : YAML::Type | Int32, key)
    return value.to_f if value.is_a? Number
    raise UserFriendlyException.new "Required setting #{key.inspect} is missing" if value.nil?
    raise UserFriendlyException.new "The setting #{key.inspect} must be an integer and not #{value.inspect}"
  end

  # Creates a new `Dirwatch::Setting` with this specific options.
  def initialize(@key : String, @directory : String, @file_match : String, @interval : Float64, @scripts : Array(String))
  end
end

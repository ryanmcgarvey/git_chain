class GitChain::Storage
  FILE_NAME = ".git_chains"
  FORMAT_VERSION = "1"

  attr_reader :path, :file_name, :file_path

  def initialize(path: nil, file_name: nil)
    @path = path || %x{pwd}.strip
    @file_name = file_name || FILE_NAME
    @file_path = @path + "/" + @file_name
  end

  def record_for(child)
    records[child.to_sym]
  end

  def update_record(child:, parent:, base:)
    records[child.to_sym] = {
      parent: parent,
      child: child,
      base: base,
    }

    save_data
  end

  def save_data
    File.write(file_path, data.to_json)
  end

  def print
    pp data
  end

  def print_branch(branch: )
    pp record_for(branch)
  end

  private

  def records
    data[:records]
  end

  def data
    @_data ||= load_data || { format_version: FORMAT_VERSION, records: {} }
  end

  def load_data
    json_data = File.read(file_path) if File.exist?(file_path)

    if json_data.nil? || json_data.empty?
      nil
    else
      post_process(
        JSON.parse(json_data, symbolize_names: true)
      )
    end
  end

  def post_process(loaded_data)
    while upgrade = UPGRADES[loaded_data[:format_version] || 0]
      loaded_data = upgrade.call(loaded_data)
    end
    return loaded_data
  end

  UPGRADES =
    {
      0 => Proc.new do |d|
        {
          format_version: 1,
          records: d,
        }
      end,
    }
end

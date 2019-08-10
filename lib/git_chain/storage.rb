class GitChain::Storage
  FILE_NAME='.git_chains'

  attr_reader :path, :file_name, :file_path
  def initialize(path: nil, file_name: nil)
    @path = path || %x{pwd}.strip
    @file_name = file_name || FILE_NAME
    @file_path = @path + "/" + @file_name
  end

  def record_for(child)
    data[child.to_sym]
  end

  def update_record(child:, parent:, base: )
    data[child.to_sym] = {
      parent: parent,
      child: child,
      base: base
    }

    save_data
  end

  def data
    @_data ||= load_data || {}
  end

  def save_data
    File.write(file_path, data.to_json)
  end

  private

  def load_data
    json_data = File.read(file_path) if File.exist?(file_path)

    if json_data.nil? || json_data.empty?
      nil
    else
      JSON.parse(json_data, symbolize_names: true)
    end
  end
end
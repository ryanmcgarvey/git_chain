class GitChain::Storage
  FILE_NAME='.git_chains'

  attr_reader :path, :file_name, :file_path
  def initialize(path: nil, file_name: nil)
    @path = path || %x{pwd}.strip
    @file_name = file_name || FILE_NAME
    @file_path = @path + "/" + @file_name
  end

  # a chain should be keyed by the child
  # each child should have at most 1 parent
  # but parents can many children than depend on them
  # hence the hash with unique branch name keys

  def data
    @_data ||= load_data || {}
  end

  def save_data
    File.write(file_path, data.to_json)
  end

  def load_data
    json_data = File.read(file_path) if File.exist?(file_path)

    if json_data.nil? || json_data.empty?
      nil
    else
      JSON.parse(json_data)
    end
  end
end
class GitChain::Storage
  FILE_NAME='.git_chains'

  # a chain should be keyed by the child
  # each child should have at most 1 parent
  # but parents can many children than depend on them
  # hence the hash with unique branch name keys

  def data
    @_data ||= load_data || {}
  end

  def save_data
    File.write(FILE_NAME, data.to_json)
  end

  def load_data
    json_data = File.read(FILE_NAME) if File.exist?(FILE_NAME)

    if json_data.empty?
      nil
    else
      Json.parse(json_data)
    end
  end
end
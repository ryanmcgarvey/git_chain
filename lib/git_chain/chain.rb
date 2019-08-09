class GitChain::Chain < Struct.new(:storage)
  def mark_branch_as_dependent(child:, parent:)
    storage.data[child] = parent
    storage.save_data
  end
end
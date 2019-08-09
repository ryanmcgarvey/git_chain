class GitChain::Runner < Struct.new(:args)
  def call
    case args.first
    when 'list'
      puts storage.list
    else
      GitChain::Chain.new(storage).mark_branch_as_dependent(
        child: GitChain.git.current_branch,
        parent: args.first
      )
    end
  end

  def storage
    GitChain::Storage.new
  end
end
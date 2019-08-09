class GitChain::Runner

  attr_reader :git, :storage, :chain
  def initialize(path:)
    @git = GitHelper.new(path, Git.open(path))
    @storage = GitChain::Storage.new(path: path)
    @chain = GitChain::Chain.new(storage, git)
  end

  def call(command, *args)
    case command
    when 'list'
      puts storage.data
    when 'add'
      chain.mark_branch_as_dependent(
        child: git.current_branch,
        parent: args[0],
        old_base: args[1]
      )
    when 'rebase'
      if args[0] == 'all'
        chain.rebase(git.current_branch, chain: true)
      else
        chain.rebase(git.current_branch, chain: false)
      end
    else
      raise "Unknown Command: #{command}"
    end
  end


end
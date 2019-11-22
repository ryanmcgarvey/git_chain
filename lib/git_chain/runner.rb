class GitChain::Runner

  attr_reader :git, :storage, :chain
  def initialize(path:)
    @git = GitHelper.new(path, Git.open(path))
    @storage = GitChain::Storage.new(path: path)
    @chain = GitChain::Chain.new(storage, git)
  end

  def call(command, *args)
    case command
    when 'show'
      show(branch: args[0])
    when 'list'
      list()
    when 'add'
      add(parent: args[0], old_base: args[1])
    when 'rebase'
      rebase(sub_command: args.first)
    else
      raise "Unknown Command: #{command}"
    end
  end

  def show(branch: nil)
    if branch
      storage.print_branch(branch: branch)
    else
      storage.print_branch(branch: git.current_branch)
    end
  end

  def list
    storage.print
  end

  def add(parent:, old_base: nil)
    chain.mark_branch_as_dependent(
      child: git.current_branch,
      parent: parent,
      old_base: old_base
    )
  end

  def rebase(sub_command: nil)
    if sub_command == 'all'
      chain.rebase_all(git.current_branch)
    else
      chain.rebase(git.current_branch)
    end
  end




end
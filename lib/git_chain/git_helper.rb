require 'git'
class GitHelper

  attr_reader :path, :git
  def initialize(path, git)
    @path = path
    @git = git
  end

  def method_missing(method, *args)
    git.send(method, *args)
  end

  def current_branch
    git_command "rev-parse --abbrev-ref HEAD"
  end

  def merge_base(branch_1, branch_2)
    git_command "merge-base #{branch_1} #{branch_2}"
  end

  def rebase_onto(new_base:, old_base:, branch:)
    git_command "rebase --onto #{new_base} #{old_base} #{branch}"
  end

  def clean?
    # status = git.status

    # status.added.empty? &&
    #   status.changed.empty? &&
    #   status.deleted.empty? &&
    #   status.untracked.empty?
    git_command("status -s").empty?
  end



  private

  def git_command(cmd)
    %x{cd #{path}; git #{cmd}}.strip
  end

end
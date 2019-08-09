require 'securerandom'
require 'git'

class GitHarness
  include RSpec::Expectations
  include RSpec::Matchers

  RELATIVE_REPO_DIR="tmp/test_repo"

  attr_reader :git, :path
  def initialize(path=RELATIVE_REPO_DIR)
    @path = path
    @sequence = 0
  end

  def create_repo
    %x{mkdir #{RELATIVE_REPO_DIR}}
    initialize_repo
    File.write("#{path}/.gitignore", ".git_chains")
    git.add(all: true)
    message = "Add git ignore"
    git.commit(message)
  end

  def cleanup_repo
    %x{rm -rf #{RELATIVE_REPO_DIR}}
  end

  def checkout(branch_name)
    git.branch(branch_name).checkout
  end

  def move_current_branch(reset: true)
    git.reset_hard('HEAD') if reset
    new_file = new_file_name
    add_file(new_file)
    git.add(all: true)
    message = "Add #{new_file}"
    git.commit(message)

    return message
  end

  def assert_base(child:,parent:)
    expect(git.merge_base(child, parent)).to eq(git.branch(parent).gcommit.sha)
  end

  def assert_not_base(child:, parent:)
    expect(git.merge_base(child, parent)).to_not eq(git.branch(parent).gcommit.sha)
  end

  private

  def add_file(name=new_file_name)
    %x{touch #{RELATIVE_REPO_DIR}/#{name}}
  end

  def new_file_name
    next_sequence
  end

  def initialize_repo
    base_git = Git.init(RELATIVE_REPO_DIR)
    @git = GitHelper.new(RELATIVE_REPO_DIR, base_git)
  end

  def next_sequence
    @sequence += 1
  end

end
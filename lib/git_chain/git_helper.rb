class GitHelper
  def current_branch
    %x|git rev-parse --abbrev-ref HEAD|
  end
end
require 'pry'
module GitChain
  class Error < StandardError; end
end

Dir[File.join(__dir__, '**', '*.rb')].each do |file|
  require file
end

module GitChain
  def self.git
    @_git ||= GitHelper.new
  end
end
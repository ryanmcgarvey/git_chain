RSpec.describe GitChain do
  let(:harness) { GitHarness.new }
  let(:subject) { GitChain::Runner.new(path: harness.path) }

  context "When I have a repo with a topic branch checked out" do
    before do
      harness.cleanup_repo
      harness.create_repo
      harness.move_current_branch
      harness.checkout("topic_a")
      harness.move_current_branch
    end

    it "can chain the topic to master" do
      subject.call('add', 'master')
      harness.move_current_branch
      harness.checkout('master')
      harness.move_current_branch
      harness.checkout('topic_a')
      subject.call('rebase')

      harness.assert_base(child: 'topic_a', parent: 'master')
    end

    it "can chain rebases down to master" do
      subject.call('add', 'master')

      harness.checkout("topic_b")
      harness.move_current_branch

      subject.call('add', 'topic_a', 'topic_a')

      harness.checkout('master')
      harness.move_current_branch
      harness.checkout('topic_a')
      harness.move_current_branch
      harness.checkout('topic_b')

      harness.assert_not_base(child: 'topic_a', parent: 'master')
      harness.assert_not_base(child: 'topic_b', parent: 'topic_a')

      subject.call('rebase', 'all')

      harness.assert_base(child: 'topic_a', parent: 'master')
      harness.assert_base(child: 'topic_b', parent: 'topic_a')
    end

    it "can chain rebases down to first branch" do

      harness.checkout("topic_b")
      subject.call('add', 'topic_a')
      harness.move_current_branch

      harness.checkout("topic_c")
      subject.call('add', 'topic_b')
      harness.move_current_branch

      harness.checkout('topic_a')
      harness.move_current_branch
      harness.checkout('topic_b')
      harness.move_current_branch
      harness.checkout('topic_c')

      harness.assert_not_base(child: 'topic_b', parent: 'topic_a')
      harness.assert_not_base(child: 'topic_c', parent: 'topic_b')

      subject.call('rebase', 'all')

      harness.assert_base(child: 'topic_b', parent: 'topic_a')
      harness.assert_base(child: 'topic_c', parent: 'topic_b')
    end

  end
end

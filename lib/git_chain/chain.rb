class GitChain::Chain < Struct.new(:storage, :git)

  def mark_branch_as_dependent(child:, parent:, old_base: nil)
    old_base = old_base || parent
    base = calculate_base(child, old_base: old_base)
    update_dependent(child: child, parent: parent, base: base)
    storage.save_data
  end

  def rebase(child)
    raise "No chain for #{child}" unless record = storage.record_for(child)
    raise "Git Directory is not clean" unless git.clean?

    old_base = record[:base]
    parent   = record[:parent]
    branch   = git.branches[parent]
    new_base = branch.gcommit

    git.rebase_onto(new_base: new_base, old_base: old_base, branch: child)

    update_dependent(child: child, parent: parent, base: new_base.sha)
  end

  def rebase_all(child)
    raise "Git Directory is not clean" unless git.clean?
    raise "No chain for #{child}" unless last_record = storage.record_for(child)

    records = [last_record]
    while new_record = storage.record_for(last_record[:parent])
      records << new_record
      last_record = new_record
    end

    records.reverse.each do |record|
      rebase(record[:child])
    end
  end

  private

  def update_dependent(child:, parent:, base:)
    base = base.sha unless base.is_a? String
    storage.update_record(child: child, parent: parent, base: base)
  end

  def calculate_base(child, old_base: nil)
    record = storage.record_for(child)
    if record && old_base.nil?
      record[:base]
    else
      old_parent = old_base || 'master'
      git.merge_base(child, old_parent)
    end
  end


end
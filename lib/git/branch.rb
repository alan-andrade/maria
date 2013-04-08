module Git
  module Branch
    extend Git::Run
    extend self

    def current
      branches = exec(:branch).split
      default = branches.index('*')
      branches[default+1]
    end

    def delete(branch)
      run :branch, '-D', branch, '-q'
    end

    def switch_to(branch)
      run(:checkout, branch, '-q')
    end

    def force_switch_to(branch)
      run(:checkout, '-B', branch, '-q')
    end

  end #/branch
end #/git

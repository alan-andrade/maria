module Git
  module Branch
    extend Git::Run
    extend self

    def current
      branch = list.find{|b| b.match /\*/ }
      branch.gsub(/\* /, '')
    end

    def exists?(name)
      list.include?(name)
    end

    def list
      exec(:branch)
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

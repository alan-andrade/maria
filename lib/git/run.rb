require 'active_support/core_ext/kernel/reporting'

module Git
  module Run
    extend self

    def run(action, *args)
      command =  "git #{action} #{args.join(' ')}"
      success = nil
      result = capture(:stderr){
        success = system(command + ' 1>/dev/null')
      }
      success or throw "Github error when called: #{command}. #{result}"
    end

    def exec(action, *args)
      `git #{action.to_s} #{args.join(' ')}`.split(/\n/)
    end

    def log(n=10)
      exec(:log, "-#{n}", '--oneline')
    end

    def status(file_path)
      result = nil
      if File.exists?(file_path)
        result = Git::Run.exec(:status, '--porcelain', file_path)
        result = result.first
      end
      result or ''
    end

    def diff_tree(branch='', sha='')
      exec('diff-tree', '--no-commit-id --name-only -r', branch, sha)
    end

    def commit(*args)
      safety_nets
      run :commit, args
    end

    def push(remote)
      safety_nets
      run(:push, remote)
    end

    private

    def safety_nets
      if Rails.env.test? and Git::Branch.current != 'test'
        throw "Not so fast! Youre using git in your tests but git was not specified in the test context.  Just add to the very top:  git: true"
      end
    end

  end
end

require 'active_support/core_ext/kernel/reporting'

module Git
  module Run
    # Git::Run
    #
    # This module extracts all the git binary calls.
    #
    # The two main methods are run and exec.
    #
    # Difference is that one will return the stdout and the other will
    # suppress it.
    extend self

    # run
    #
    # :action -> what git action you want to run?
    # :args -> any arguments that action could receive
    def run(action, *args)
      command =  "git #{action} #{args.join(' ')}"
      success = nil
      result = capture(:stderr){
        success = system(command + ' 1>/dev/null')
      }
      success or throw "Github error when called: #{command}. #{result}"
    end

    # exec
    #
    # Similar to run but will return the stdout result
    # as an array.
    def exec(action, *args)
      `git #{action.to_s} #{args.join(' ')}`.split(/\n/)
    end

    # log
    #
    # Returns the git log of the current branch with the oneline formatting.
    def log(n=10)
      exec(:log, "-#{n}", '--oneline')
    end

    # status
    #
    # Return the status of a file so that we can parse it and create a
    # new Status object for a file.
    def status(file_path)
      result = nil
      if File.exists?(file_path)
        result = Git::Run.exec(:status, '--porcelain', file_path)
        result = result.first
      end
      result or ''
    end

    # diff_tree
    #
    # Will return the files that are in a different branch or commit.
    def diff_tree(branch='', sha='')
      exec('diff-tree', '--no-commit-id --name-only -r', branch, sha)
    end

    # commit
    #
    # Apply a commit after using some safety net method that won't let
    # us continue if we're in a branch that can harm your changes.
    def commit(*args)
      safety_nets
      run :commit, args
    end

    # push
    #
    # Push last commits to a remote repo.
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

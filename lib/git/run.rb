module Git
  module Run
    extend self

    def run(action, *args)
      command =  "git #{action} #{args.join(' ')}"
      system(command+' 1>/dev/null') or throw "Github error when called: #{command}"
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

    def diff_tree(sha)
      exec('diff-tree', '--no-commit-id --name-only -r', sha)
    end

  end
end

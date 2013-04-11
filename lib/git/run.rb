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

  end
end

module AutoBrewster
  class CLI
    def initialize(args)
      @args = args
    end

    def execute!
      AutoBrewster.send(get_action)
    end

    def get_action
      return :compare_screens if @args.length < 1

      if !AutoBrewster.respond_to?(@args[0])
        raise "Action \"#{@args[0]}\" not available on AutoBrewster"
      else
        return @args[0].to_sym
      end
    end
  end
end

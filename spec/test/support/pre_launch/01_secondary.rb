module AutoBrewster
  module Test
    module Env
      class << self
        attr_accessor :override_value

        def override_value
          'set_in_secondary'
        end
      end
    end
  end
end

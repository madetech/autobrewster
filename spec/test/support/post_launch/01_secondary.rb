module AutoBrewster
  module Test
    module Env
      class << self
        attr_accessor :override_value

        def override_value
          'set_in_post_launch'
        end
      end
    end
  end
end

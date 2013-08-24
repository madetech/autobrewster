module AutoBrewster
  module Test
    module Env
      class << self
        attr_accessor :test_value,
                      :override_value

        def test_value
          'set_in_env'
        end

        def override_value
          'set_in_env'
        end
      end
    end
  end
end

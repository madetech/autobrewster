module AutoBrewster
  class Screenshot
    attr_accessor :server,
                  :path,
                  :url_paths,
                  :screen_widths,
                  :failed_fast

    def initialize(server, path, url_paths, screen_widths)
      @server = server
      @path = path
      @url_paths = url_paths
      @screen_widths = screen_widths
    end

    def capture(output_directory)
      @url_paths.each do |label, path|
        @screen_widths.each do |width|
          output_path = get_output_path(output_directory, label, width)
          if File.exist?(output_path)
            puts "Screenshot already exists for #{label} at #{width}. Skipping..."
          else
            puts `phantomjs #{snap_js_path} "#{get_url(path)}" "#{width}" "#{output_path}"`
          end
        end
      end
    end

    def compare_captured_screens(failfast = false)
      create_diff_dir
      failures = 0

      @url_paths.each do |label, path|
        @screen_widths.each do |width|
          check_source_compare_screens_exist(label, width)

          source_path = get_output_path(:source, label, width)
          compare_path = get_output_path(:compare, label, width)
          diff_path = get_output_path(:diff, label, width)

          output = `compare -fuzz 20% -metric AE -highlight-color blue #{source_path} #{compare_path} #{diff_path} 2>&1`

          failures += get_failure_count(output, label, width)

          if failfast
            @failed_fast = true
            exit 1
          end
        end
      end

      exit 1 if failures > 0
    end

    def check_source_compare_screens_exist(label, width)
      [get_output_path(:source, label, width), get_output_path(:compare, label, width)].each do |path|
        raise "Screenshot at #{path} does not exist" unless File.exist?(path)
      end
    end

    def clear_source_screens
      clear_screenshot_directory(:source)
    end

    def clear_compare_screens
      clear_screenshot_directory(:compare)
    end

    def clear_diff_screens
      clear_screenshot_directory(:diff)
    end

    private
    def get_output_path(directory, label, width)
      "#{@path}/screens/#{directory}/#{label}-#{width}.jpg"
    end

    def get_url(path)
      "#{@server.get_host_with_protocol_and_port}#{path}"
    end

    def create_diff_dir
      FileUtils.mkdir_p("#{@path}/screens/diff")
    end

    def clear_screenshot_directory(directory)
      FileUtils.rm_rf Dir.glob("#{@path}/screens/#{directory}/*.jpg")
    end

    def snap_js_path
      File.expand_path('../../../snap.js',  __FILE__)
    end

    def get_failure_count(output, label, width)
      if output.strip! != "0"
        puts "#{label} at #{width} wide doesn't match source screen"
        return 1
      end

      return 0
    end
  end
end

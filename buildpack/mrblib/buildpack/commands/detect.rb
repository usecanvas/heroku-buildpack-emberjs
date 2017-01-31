module Buildpack::Commands
  class Detect
    def self.detect(options)
      options["detect"]
    end

    def initialize(output_io, error_io, build_dir)
      @output_io = output_io
      @error_io  = error_io
      @build_dir = build_dir
      @output_io.puts "Build dir: #{build_dir}"
    end

    def run
      package_json_path = "#{@build_dir}/package.json"

      @output_io.puts "package.json path: #{package_json_path}"

      if File.exist?(package_json_path)
        json = JSON.parse(File.read(package_json_path))

        @output_io.puts "package.json found: #{json}"

        if (json["devDependencies"] || {}).merge(json["dependencies"] || {})["ember-cli"]
          @output_io.puts "emberjs"
          exit 0
        end
      end

      exit 1
    end
  end
end

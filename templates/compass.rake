namespace :compass do
  desc "Regenerate css files as their sass source files change."
  task :watch do
    config_file = File.join( Rails.root.to_s, "config", "compass.yml" )
    configuration = YAML.load( File.read( config_file ) )

    config = "config/compass.rb"
    command = "compass watch --sass-dir #{configuration['sass_dir']} --css-dir #{configuration['css_dir']} --config #{config}"
    puts command
    system( command )
  end

  desc "If no sass file exists for a css file, create it using css2sass."
  task :import do
    def css2sass_installed?
      `which css2sass`.blank? ? false : true
    end

    unless css2sass_installed?
      puts "css2sass not installed.  Import terminated."
      return false
    end

    config_file = File.join( Rails.root.to_s, "config", "compass.yml" )
    configuration = YAML.load( File.read( config_file ) )
    css_dir = configuration[:css_dir]
    sass_dir = configuration[:sass_dir]

    files = Dir["#{css_dir}/*.css"].map{ |f|
      [f, f.gsub(/^#{css_dir}/, sass_dir).gsub(/\.css$/, ".sass")]
    }

    files.each{ |f|
      unless File.exists?(f[1])
        dest_dir = File.dirname(f[1])
        `mkdir -p #{dest_dir}` unless File.exists?(dest_dir)

        puts "    generating #{f[0]} --> #{f[1]}"
        `css2sass #{f[0]} #{f[1]}`
      else
        puts "    exists #{f[1]}"
      end
    }
  end
end

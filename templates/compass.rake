namespace :compass do
  desc "Regenerate css files as their sass source files change."
  task :watch do
    config = "config/compass.rb"
    css_dir = "public/stylesheets"
    sass_dir = "public/sass_stylesheets"

    system("compass -w --sass-dir #{sass_dir} --css-dir #{css_dir} --config #{config}")
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

    config = "config/compass.rb"
    css_dir = "public/stylesheets"
    sass_dir = "public/sass_stylesheets"

    files = `find #{css_dir} -name "*.css"`.split.map{ |f|
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

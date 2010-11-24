class CompassSassGenerator < Rails::Generators::Base
  desc "Sets your application up to use SASS stylesheets."
  
  class_option :http_path, :type => :string, :desc => "???", :default => "/"
  class_option :images_dir, :type => :string, :desc => "Directory where images are kept", :default => "images"
  class_option :output_style, :type => :string, :desc => "CSS output mode (nested, expanded, compact, or compressed)", :default => "nested"
  class_option :project_type, :type => :string, :desc => "Type of project being integrated with.", :default => "stand_alone"
  class_option :sass_dir, :type => :string, :desc => "Directory for .sass sheets.", :default => "public/sass_stylesheets"
  class_option :style_dir, :type => :string, :desc => "Directory for .css sheets.", :default => "public/stylesheets"

  source_root File.expand_path("../templates", __FILE__)
  
  def create_compass_tasks
    assign_opts
    template("compass.rake", "lib/tasks/compass.rake")
  end
  
  def create_compass_config
    assign_opts  
    template("compass.rb", "config/compass.rb")
    template("compass.yml", "config/compass.yml")
  end
  
  def create_compass_files
    assign_opts
    directory("stylesheets", "public/stylesheets")
    directory("sass_stylesheets", "public/sass_stylesheets")

    unless compass_gem_installed?
      puts "WARNING: compass may not be installed properly.  compass binary not found.  Try 'gem install compass'"
    end

  end
  
  def add_compass_gem_to_gemfile
    say "Adding compass to your Gemfile"
    append_file "Gemfile", "\n\n# added by compass_sass generator\ngem \"compass\"\n" 
  end
  
  def explain_what_just_happened
    assign_opts
    say <<-EOS

New tasks:
    rake compass:watch           # updates css files whenever your sass files change
    rake compass:import          # takes css files you've already written and translates them into sass

To import your new stylesheets add the following lines to your layout's head':
  <head>
    <%= stylesheet_link_tag 'screen', :media => 'screen' %>
    <%= stylesheet_link_tag 'print', :media => 'print' %>
    
    <!--[if lt IE 7]>
      <%= stylesheet_link_tag 'ie' %>
    <![endif]-->
  </head>
  
EOS
  end

  protected
  # displays when generator is run with no arguments
  def banner
    "Usage #{$0} compass_sass somethingelse whoknowswhat"
  end

  def compass_gem_installed?
    `which compass`.blank? ? false : true
  end
  
  def assign_opts
    for key, value in options
      instance_variable_set "@#{key}", value
    end
    nil
  end
end



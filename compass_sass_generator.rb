require "ruby-debug"

class CompassSassGenerator < Rails::Generator::Base
  # you can make variables available to the templates like so:
  #
  # attr_reader :var
  #
  # then set @var in initialize or manifest.  Or just pass in @var
  # as part of the :assigns hash when running m.template

  def initialize runtime_args, runtime_options = {}
    super
    # do stuff here
  end

  def manifest
    action = File.basename($0)
    case action
    when "generate"
      puts "Installing compass/sass-related files and tasks."
    when "destroy"
      puts "Please fill out a brief survey explaining why you are dissatisfied with this generator"
    end

    record do |m|
      # Sample actions:
      #
      # create a directory
      # m.directory("app/views/#{singular_name}/")
      #
      # copy a file from templates folder
      # m.file("stuff.css", "public/stylesheets/#{singular_name}/stuff.css")
      #
      # evaluate
      # m.template( "scaffold_show.rb", "app/views/target/show.html.erb,
      #             :assigns => { :named => @named, :model_name => @model_name } )
      #
      # create a migration
      # m.migration("totally_screw_up_database.rb", migration_directory)

      m.file("compass.rake", "lib/tasks/compass.rake")
      m.file("compass.rb", "config/compass.rb")
      m.directory("public/stylesheets")
      m.directory("public/sass_stylesheets")

      unless compass_gem_installed?
        puts "WARNING: compass may not be installed properly.  Try 'gem install compass'"
      end

      if stylesheets_dir_empty?("public/stylesheets")
        puts "No existing css detected.  Generating defaults."
        for label in %w(ie screen print)
          m.file("#{label}.css", "public/stylesheets/#{label}.css")
          m.file("#{label}.sass", "public/sass_stylesheets/#{label}.sass")
        end

        puts <<-EOS
To import your new stylesheets add the following lines of HTML (or equivalent) to your webpage:
<head>
  <link href="/stylesheets/screen.css" media="screen, projection" rel="stylesheet" type="text/css" />
  <link href="/stylesheets/print.css" media="print" rel="stylesheet" type="text/css" />
  <!--[if IE]>
      <link href="/stylesheets/ie.css" media="screen, projection" rel="stylesheet" type="text/css" />
  <![endif]-->
</head>

EOS
      end
    end
  end

  protected
  # displays when generator is run with no arguments
  def banner
    "Usage #{$0} compass_sass somethingelse whoknowswhat"
  end

  def compass_gem_installed?
    `which compass`.blank? ? false : true
  end

  def stylesheets_dir_empty?( dir )
    Dir[File.join(dir, "*")].blank?
  end
end



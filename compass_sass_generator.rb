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
      puts "Thank you for using this generator.  Good fortune be with you."
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


      if compass_gem_installed?
        # should translate CSS files into SASS
        `compass --config config/compass.rb --css-dir public/stylesheets --sass-dir public/sass_stylesheets shoriyuken`
      else
        puts "WARNING: compass may not be installed properly.  Try 'gem install compass'"
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

  def css2sass_installed?
    `which css2sass`.blank? ? false : true
  end
end



if File.exist?( "compass.yml" )
  configuration = YAML.load( File.read( "compass.yml" ) )
else
  configuration = { "project_type" => :stand_alone, 
                    "http_path" => "/",
                    "css_dir"   => "<%= @css_dir %>",
                    "sass_dir"  => "<%= @sass_dir %>",
                    "images_dir"  => "<%= @images_dir %>",
                    "output_style" => :<%= @output_style %>
  }
end

# configuration for compass plugin
# Require any additional compass plugins here.
project_type = :stand_alone

# Set this to the root of your project when deployed:
http_path = configuration["http_path"]
css_dir = configuration["css_dir"]
sass_dir = configuration["sass_dir"]
images_dir = configuration["images_dir"]
output_style = configuration["output_style"]

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true


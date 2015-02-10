require 'builder'

activate :livereload, :apply_js_live => false

activate :syntax, :line_numbers => true

# load .env variables
activate :dotenv

###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :markdown_engine, :kramdown
set :markdown, :parse_block_html => true

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :site_domain, 'http://developer.samsungsami.io/'

# Build-specific configuration
configure :build do
  sitemap.rebuild_resource_list!
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

# # Configuration of the swiftype extension
activate :swiftype do |swiftype|
  # swiftype_config = YAML.load_file('./swiftype.yaml')
  swiftype.api_key = ENV['swiftype_api_key']
  swiftype.engine_slug = 'samihub'
  swiftype.pages_selector = lambda { |p| p.path.match(/\.html/) && p.metadata[:options][:layout] == nil }
  swiftype.process_html = lambda { |f| f.search('td.gutter').remove }
  # swiftype.generate_sections = lambda { |p| (p.metadata[:page]['tags'] ||= []) + (p.metadata[:page]['categories'] ||= []) }
  # swiftype.generate_info = lambda { |f| TruncateHTML.truncate_html(strip_img(f.to_s), blog.options.summary_length, '...') }
end

helpers do
  def nav_link_to(link, url, opts={})
    if current_page.url.chomp('/').match(/^#{url.chomp('/')}/)
      prefix = '<li class="nav-item active">'
    else
      prefix = '<li class="nav-item">'
    end
    prefix + link_to(link, url, opts) + "</li>"
  end

  def active_link_to(link, url, opts={})
    if current_page.url.chomp('/') == url.chomp('/')
      opts = { class: 'active' }
    end
    link_to link, url, opts
  end

  def sub_pages(dir)
    sitemap.resources.select do |resource|
      resource.path.start_with?(dir)
    end
  end

  def page_title(resource)
    page_data(resource)['title']
  end

  def page_data(resource)
    resource.metadata[:page]
  end

  def page_or_index(path)
    page_resource = sitemap.find_resource_by_path("#{path}.html")
    page_resource ||= sitemap.find_resource_by_path("#{path}/index.html")
  end

  def github_link(link, resource, opts={})
    relative_source_path = resource.source_file.gsub(/#{Dir.pwd}\//, '')
    github_repo_base = "https://github.com/samihub/samihub.com/edit/master"
    link_to link, "#{github_repo_base}/#{relative_source_path}", opts
  end

  def published_children(resource)
    resource ? resource.metadata[:page]['nav'] : nil
  end

  def resource_to_nav_key(resource)
    resource.url.gsub(resource.parent.url.chomp('.html'), '').chomp('.html').chomp('/')
  end

  def previous_in_tree(resource)
    prev_page = if published_children(resource)
      page_or_index("#{resource.url}#{published_children(resource).last}")
    else
      resource
    end

    prev_page = previous_in_tree(prev_page) if published_children(prev_page)
    prev_page
  end

  def next_in_tree(resource)
    next_page = is_last_published_child(resource) ? next_in_tree(resource.parent) : next_sibling(resource)
    next_page
  end

  def is_last_published_child(resource)
    resource.parent ? published_children(resource.parent).last.chomp('.html').chomp('/') == resource_to_nav_key(resource) : nil
  end

  def next_sibling(resource)
    siblings = published_children(resource.parent)
    if siblings
      parent_path = resource.parent.url
      page_key = resource_to_nav_key(resource)
      page_index = siblings.index page_key
      page_index ? page_or_index("#{parent_path}#{siblings.at(page_index + 1)}") : nil
    end
  end

  def nearest_resource(resource)
    siblings = published_children(resource.parent)
    parent_path = resource.parent.url
    page_key = resource_to_nav_key(resource)
    page_index = siblings.index page_key

    return Hash[prev: nil, next: nil] unless page_index

    prev_page = page_index > 0 ? page_or_index("#{parent_path}#{siblings.at(page_index - 1)}") : nil

    if prev_page and published_children(prev_page)
      prev_page = previous_in_tree(page_or_index("#{prev_page.url}#{published_children(prev_page).last}"))
    end

    if !prev_page
      prev_page = resource.parent
    end

    prev_page = nil if resource.parent.url == '/'

    next_page = if published_children(resource)
      first_child_path = "#{resource.url}#{published_children(resource).first}"
      page_or_index(first_child_path)
    else
      page_index < siblings.count ? page_or_index("#{parent_path}#{siblings.at(page_index + 1)}") : nil
    end

    next_page = next_in_tree(resource) if !published_children(resource) and is_last_published_child(resource)

    next_page = nil if next_page and next_page.parent.url == '/'

    Hash[
      prev: prev_page,
      next: next_page
    ]
  end

  def next_resource(resource)
    nearest_resource(resource)[:next]
  end

  def prev_resource(resource)
    nearest_resource(resource)[:prev]
  end
end

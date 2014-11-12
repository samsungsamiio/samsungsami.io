#!/usr/bin/env ruby

require 'YAML'

DOCS_DIR = File.join(Dir.pwd, 'source')

def create_dir(dir)
  return unless dir
  Dir.mkdir(dir) unless Dir.exists?(dir)
end

def create_md_file(file, directory, children=[])
  filename = file.split(' - ')[0]
  title = file.split(' - ')[1]
  file = File.join(directory, filename)
  return if File.exists? file
  nav = ''
  if children
    nav ="nav:\n"
    children.each do |child|
      child = child.keys[0] if child.is_a? Hash
      next if child.match(/index|nav/)
      nav +="  - '#{child.split('.')[0].chomp('/')}'\n"
    end
  end
  if title
    File.open(File.join(directory, filename), "w") do |f|
      f.write <<eos
---
title: "#{title}"
#{nav}
---
# #{title}
eos
    end
  end

end

def process_contents(tree, parent)
  tree.keys.each do |dir|
    directory = File.join(parent, dir.chomp('/'))
    create_dir directory
    tree[dir].each do |dir_content|
      if dir_content.is_a? String
        children = nil
        if dir_content.split(' - ')[0].match(/index\.md/)
          children = tree[dir]
        end
        create_md_file(dir_content, directory, children)
      else
        process_contents(dir_content, directory)
      end
    end
  end
end

process_contents(YAML.load_file('data/scaffold.yml'), DOCS_DIR)

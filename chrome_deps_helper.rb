#!/usr/bin/env ruby

require 'yaml'

def DEPS_to_rb
  puts 'start parsing chromium DEPS'
  f=File.read('../src/DEPS')
  f.gsub!('\':', '\'=>')
  f.gsub!("' : '", "' => '")
  f.gsub!('True', 'true')
  f.gsub!('False', 'false')
  f.gsub!('deps = {', '@deps = {')
  f.gsub!('vars = {', "def Var str\n\t@vars[str]\nend\n@vars = {")
  File.write('/tmp/DEPS.rb', f)
end

def download( url, dir )
  if url == nil || url.length < 5
    puts 'wrong url', url
  else
    splitted = url.split '@'
    url = splitted[0]
    commit = splitted[1]

    cmd = "git clone -o #{commit} #{url} --depth=1 #{dir}"
    IO.popen(cmd).each do |line|
      puts line.chomp
    end
  end
end

DEPS_to_rb()
require '/tmp/DEPS'

counter = 0
for dep in @deps
  puts '------------------=-=-=-=-=-=------------------'
  dir = dep[0]
  if dep[1].class == Hash
    url = dep[1]['url']
    condition = dep[1]['condition']
  else
    url = dep[1]
    condition = false
  end


  if condition
    if @vars[condition] == true
      download(url, dir)
    end
  else
    download(url, dir)
  end

  counter += 1
end

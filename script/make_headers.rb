#!/usr/bin/env ruby

files = %x(git ls-files).split

# Blacklist instead of whitlist to have more (perceived?) control.
#
# Ignore:
# - Hidden files.
# - Files with no extension.
# - Files in public directory.
# - Files in vendor directory.
# - Files in script (because they need the #! at the top).
# - Logs, sql-files, options files.
# - Gemfile.lock.
# - gemspec.
# - YAML-files.
# - Example config files.
# - ERB-files / HAML-files.
# - SASS-files.
# - Markdown files.
# - README files (something.yml.README).

files = files.grep(/.+\./).find_all do |f|
  f !~ %r@
    public/ |
    vendor/ |
    script/ |
    \.sql$  |
    \.log$  |
    \.opts$ |
    \.lock$ |
    \.yml$ |
    \.example$ |
    \.gemspec$ |
    \.erb$  |
    \.haml$ |
    \.sass$ |
    \.md$   |
    README$
  @x
end

header = IO.read(File.expand_path "copyright-header", File.dirname(__FILE__))

files.each do |file|
  puts file
  contents = IO.read(file).split("\n")
  if contents.first =~ /Copyright/
    contents.shift while contents.first =~ /^#/
  end

  contents.shift if contents.first =~ /^$/

  File.open(file, "w") do |f|
    f.write header
    f.write "\n"
    f.write contents.join("\n")
  end
end

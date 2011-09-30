#!/usr/bin/env ruby

# Supply environment and field/key as arguments and this script will return the
# associated value from config/database.yml.
require 'yaml'

file = File.join(File.dirname(__FILE__), '../config/database.yml')
(environment, field) = *ARGV

print YAML.load(IO.read file)[environment][field]

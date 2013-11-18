# 設定ファイル読み込み(AWS初期設定付き)

require 'rubygems'
require 'yaml'
require 'aws-sdk'
require 'net/http'

config_file = File.join(File.dirname(__FILE__), "config.yml")

unless File.exist?(config_file)
  puts "config.yml doesn't exists."
  exit 1
end

config = YAML.load(File.read(config_file))

unless config.kind_of?(Hash)
  puts "config.yml is not YAML file."
  exit 1
end

AWS.config(config["aws"])

CONFIG = config

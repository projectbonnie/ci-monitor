# Top level include file that brings in all the necessary code
require 'bundler/setup'

require 'pry'
require 'rufus-scheduler'
require 'blinky'

require_relative 'monitor-job'
require_relative 'light'

APP_CONFIG = YAML.load_file(File.expand_path("../../config.yml", __FILE__))['config']

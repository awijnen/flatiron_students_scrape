# config.ru

require './controller'
run Sinatra::Application

$stdout.sync = true

require 'watir-webdriver'
require 'headless'

headless = Headless.new
headless.start
at_exit do
  headless.destroy
end

@browser = Watir::Browser.new

data = {}

@browser.goto('http://localhost:9615')

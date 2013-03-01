require 'watir-webdriver'
require 'headless'

headless = Headless.new
headless.start
at_exit do
    headless.destroy
end

browser = Watir::Browser.new
browser.goto "http://google.com"
puts browser.html

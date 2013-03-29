require 'watir-webdriver'
require 'selenium/server'
 
class AmazonSearch
  def initialize
    @browser = Watir::Browser.new(:remote, :url => "http://127.0.0.1:4444/wd/hub", :desired_capabilities => :htmlunit)
  end
  
  def search_test
    begin
      @browser.goto("http://www.amazon.com")
      @browser.select_list(:id, "searchDropdownBox").select("Books")
      @browser.text_field(:name, 'field-keywords').set("star wars")
      @browser.button(:alt, "Go").click
      search_test_verify
    ensure
      @browser.close
    end
  end
  
  def search_test_verify
    testResult = @browser.text.match(/Showing .* of .* Results/)
    if testResult != nil
      puts "Result: #{testResult}"
      puts "PASS: Results Count verified."
    else
      puts "FAIL: Results Count not verified."
    end
    
    if @browser.title == "Amazon.com: star wars: Books"
      puts "Result: Title was #{@browser.title}"
      puts "PASS: Title was reflective of content."
    else
      puts "FAIL: Title was not reflective of content."
    end
  end
end
 
server = Selenium::Server.new("selenium-server-standalone-2.0b2.jar", :background => true)
server.start
 
runner = AmazonSearch.new
runner.search_test
 
server.stop

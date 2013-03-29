require 'rspec'
require 'watir-webdriver'
 
describe "An Amazon search" do
  it "should display results range" do
    @browser = Watir::Browser.new :firefox
    @browser.goto("http://www.amazon.com")
    @browser.select_list(:id, "searchDropdownBox").select("Books")
    @browser.text_field(:name, 'field-keywords').set("star wars")
    @browser.button(:alt, "Go").click
    @browser.text.should match(/Showing .* of .* Results/)
    @browser.close
  end
 
  it "should reflect the search context in the title" do
    @browser = Watir::Browser.new :firefox
    @browser.goto("http://www.amazon.com")
    @browser.select_list(:id, "searchDropdownBox").select("Books")
    @browser.text_field(:name, 'field-keywords').set("star wars")
    @browser.button(:alt, "Go").click
    @browser.title.should == "Amazon.com: star wars: Books"
    @browser.close
  end
end
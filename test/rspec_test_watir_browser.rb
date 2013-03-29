require 'rspec'
require 'watir-webdriver'
 
describe "An Amazon search" do
  before :each do
    @browser = Watir::Browser.new :firefox
    @browser.goto("http://www.amazon.com")
  end
 
  it "should display results range" do
    @browser.select_list(:id, "searchDropdownBox").select("Books")
    @browser.text_field(:name, 'field-keywords').set("star wars")
    @browser.button(:alt, "Go").click
    @browser.text.should match(/Showing .* of .* Results/)
  end
 
  it "should reflect the search context in the title" do
    @browser.select_list(:id, "searchDropdownBox").select("Books")
    @browser.text_field(:name, 'field-keywords').set("star wars")
    @browser.button(:alt, "Go").click
    @browser.title.should == "Amazon.com: star wars: Books"
  end
 
  after :each do
    @browser.close
  end
end
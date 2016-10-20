require_relative '../app'
require 'capybara/rspec'
require 'capybara/poltergeist'

Sinatra::Application.set :logging, false
Capybara.app = Sinatra::Application
Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 1

describe "Workshop", type: :feature do

  it "simple" do
    visit '/simple'
    expect(page).to have_content 'hello'
  end

  # The default rack-test does not respect visibility
  it "hidden" do
    visit '/hidden'
    expect(page).to have_content('hello') # even though it's hidden
  end

  it "list", js: true do
    visit '/list'
    expect(page).to have_css('li', text: 'even', count: 5)
  end

  it "list", js: true do
    visit '/slow_list'
    # confirm this slow list eventually has 5 <li>even</li>
  end

  it "delayed hide", js: true do
    visit '/delayed_hide'
    # confirm that "hello" is not on the page
  end

  it "three stages", js: true do
    visit '/three_stages'
    # click on "first", then "second", then confirm that "third" appears
  end

  it "delete", js: true do
    visit '/delete'
    # click "delete" and confirm "CONTENT" is not there
  end

  it "text input", js: true do
    visit '/text_input'
    # Put "Jane Doe" in for the input field
    # click on "Submit"
    # confirm page says, "Hi Jane Doe"
  end
end

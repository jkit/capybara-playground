require_relative '../app'
require 'capybara/rspec'
require 'capybara/poltergeist'

Sinatra::Application.set :logging, false

Capybara.app = Sinatra::Application

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
#Capybara.javascript_driver = :selenium

Capybara.javascript_driver = :poltergeist

Capybara.default_max_wait_time = 1

describe "local", type: :feature do
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
    expect(page).to have_css('li', text: 'even', count: 1)
    expect(page).to have_css('li', text: 'even', count: 2)
    expect(page).to have_css('li', text: 'even', count: 3)
    expect(page).to have_css('li', text: 'even', count: 4)
    expect(page).to have_css('li', text: 'even', count: 5)
  end

  it "delayed hide", js: true do
    visit '/delayed_hide'
    expect(page).to have_no_content('hello')
  end

  it "three stages this will fail", js: true do
    visit '/three_stages'
    click_on('First')
    click_on('Second')
    expect {
      expect(page).to have_content('third', wait: 0)
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "three stages", js: true do
    visit '/three_stages'
    click_on('First')
    click_on('Second')
    expect(page).to have_content('third', wait: 3)
  end

  it "delete", js: true do
    visit '/delete'
    click_on('Delete') # button text
    #expect(page).to_not have_content('CONTENT') # Is this okay?
    expect(page).to have_no_content('CONTENT', wait: 3)
  end

  it "three stages not have_content", js: true do
    visit '/three_stages'
    click_on('First')
    click_on('Second')
    expect(page).to_not have_content('third', wait: 3)
    expect(page).to have_no_content('third', wait: 3)
    expect(page).to have_content('third', wait: 3)
  end

  it "text input", js: true do
    visit '/text_input'
    fill_in "Full Name", with: "Jane Doe" # label text
    click_on('Submit') # link test
    expect(page).to have_content('Hi Jane Doe', wait: 3)
  end

  it "js undefined var", js: true do
    expect {
      visit '/js_undefined_var'
    }.to raise_error(Capybara::Poltergeist::JavascriptError)
  end

  # Poltergeist should notice the js syntax error, but it doesn't
  #it "js syntax error", js: true do
  #  expect {
  #    visit '/js_syntax_error'
  #  }.to raise_error(Capybara::Poltergeist::JavascriptError)
  #end
end

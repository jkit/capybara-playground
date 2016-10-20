require_relative '../app'
require 'capybara/rspec'
require 'capybara/poltergeist'

Sinatra::Application.set :logging, false

Capybara.app = Sinatra::Application

Capybara.default_max_wait_time = 1

# This is used for debugging: page.driver.debug
$console_output = StringIO.new
Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app,
    phantomjs_logger: $console_output,
    js_errors: true,
    inspector: true,
  )
end
Capybara.javascript_driver = :poltergeist_debug

describe "local", type: :feature do
  before(:each) do
    $console_output.truncate(0)
  end

  it "js undefined onready", js: true do
    visit '/js_undefined_onready'
    expect($console_output.string).to be_empty
  end

  it "slow list", js: true do
    visit '/slow_list'
    expect(page).to have_css('li', text: 'even', count: 5, wait: 5)
    expect($console_output.string).to be_empty
  end
end

require 'capybara/rspec'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.current_driver = :selenium

describe "Production", type: :feature do
  before(:each) do
    Capybara.current_driver = :selenium

    # hack to bring browser to foreground
    page.save_screenshot('/tmp/out.png')
  end

  it "searches" do
    visit 'https://www.google.com/'
    fill_in 'q', with: 'summit personalized learning'
    find('input[name=q]').native.send_keys(:return)
    expect(page).to have_content 'EdSurge'
    expect(page).to have_content 'Facebook'
  end

  it "searches" do
    visit 'https://www.summitlearning.org/'
    expect(page).to have_content 'Bring personalized learning to your students.'
  end
end

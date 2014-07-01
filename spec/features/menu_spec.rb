require 'spec_helper'

describe 'Menu', :type => :feature, :js => true do
  let(:admin) { create(:admin_user) }

  before(:each) do
    # login
    visit '/rademade_admin'

    fill_in 'data_email', with: admin.email
    fill_in 'data_password', with: admin.password

    first('#data_submit_action button').click
    find('#sidebar-nav')
  end

  it 'should have "dashboard" item' do
    expect(page).to have_content 'Home'
  end

  it 'should have root models' do
    expect(page).to have_content 'Users'

    expect(page).to have_content 'Posts'
  end

  it 'should show inner menu items on click' do
    click_on('Users')

    expect(page).to have_content 'Add user'
    expect(page).to have_content 'Users list'
  end
end
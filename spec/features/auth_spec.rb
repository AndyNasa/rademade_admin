# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Auth', :type => :feature, :js => true do

  let(:user) do
    create :simple_user, :password => '12345678'
  end

  let(:admin) do
    create :admin_user, :password => '12345678'
  end

  context 'without session' do

    it 'should redirect to login page' do
      visit rademade_admin_path
      expect(page).to have_content 'Log in'
    end

    it 'should login with admin user' do
      visit rademade_admin_path

      fill_in 'data_email', :with => admin.email
      fill_in 'data_password', :with => '12345678'

      click_on 'Log in'
      find('#sidebar-nav')
      expect(page).to have_content 'Dashboard'
    end

    it 'should not login with non admin user' do
      visit rademade_admin_path

      fill_in 'data_email', :with => user.email
      fill_in 'data_password', :with => '12345678'

      click_on 'Log in'
      expect(page).to have_content 'Access denied'
    end

    it 'should not login with wrong password' do
      visit rademade_admin_path

      fill_in 'data_email', :with => user.email
      fill_in 'data_password', :with => 'somewrongpass'

      click_on 'Log in'
      expect(page).to have_content 'Incorrect password'
    end

  end

  context 'when signed in' do

    before(:each) do
      visit rademade_admin_path

      fill_in 'data_email', :with => admin.email
      fill_in 'data_password', :with => '12345678'

      click_on 'Log in'
    end

    it 'should sign out' do
      click_on 'Exit'

      expect(page).to have_content 'Log in'
    end

  end

end

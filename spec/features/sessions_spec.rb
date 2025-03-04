# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Sessions", type: :feature do

  # -------------------------------------------------------------
  # start DMPTool customization
  # Initialize the is_other org
  # -------------------------------------------------------------
  include DmptoolHelper

  before(:each) do
    mock_blog
  end
  # -------------------------------------------------------------
  # end DMPTool customization
  # -------------------------------------------------------------

  let(:user) { create(:user) }

  scenario "User signs in successfully with email and password", :js do
    # Setup
    visit root_path

    # -------------------------------------------------------------
    # start DMPTool customization
    # Access the signin form
    # -------------------------------------------------------------
    access_sign_in_modal
    # -------------------------------------------------------------
    # end DMPTool customization
    # -------------------------------------------------------------

    # Action
    fill_in :signin_user_email, with: user.email
    fill_in :signin_user_password, with: user.password
    click_button "Sign in"

    # Expectation
    expect(current_path).to eql(plans_path)
    expect(page).to have_text(user.firstname)
    expect(page).to have_text(user.surname)
  end

  scenario "User fails sign in with email and password", :js do
    # Setup
    visit root_path

    # -------------------------------------------------------------
    # start DMPTool customization
    # Access the signin form
    # -------------------------------------------------------------
    access_sign_in_modal
    # -------------------------------------------------------------
    # end DMPTool customization
    # -------------------------------------------------------------

    # Action
    fill_in :signin_user_email, with: user.email
    fill_in :signin_user_password, with: "rong-password"
    click_button "Sign in"

    # Expectation
    expect(current_path).to eql(root_path)
    expect(page).not_to have_text(user.firstname)
    expect(page).not_to have_text(user.surname)
    expect(page).to have_text("Error")
  end

end

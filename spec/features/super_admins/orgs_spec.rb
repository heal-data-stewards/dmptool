# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SuperAdmins Orgs", type: :feature, js: true do

  include LinksHelper

  before do
    @org = create(:org)
    @user = create(:user, :super_admin, org: @org)
    sign_in_as_user(@user)
  end

  scenario "Super admin submits invalid data" do
    # -------------------------------------------------------------
    # start DMPTool customization
    # DMPTool changed the label of the admin menu
    # -------------------------------------------------------------
    # click_link "Admin"
    click_link "Admin Features"
    # -------------------------------------------------------------
    # end DMPTool customization
    # -------------------------------------------------------------

    click_link "Organisations"
    click_link "Create Organisation"
    expect(page).to have_text("New organisation")
    click_button "Save"
    expect(current_path).to eql(super_admin_orgs_path)
    expect(page).to have_text("Error: Unable to create the organisation.")
  end

  scenario "Super admin adds links" do
    # -------------------------------------------------------------
    # start DMPTool customization
    # DMPTool changed the label of the admin menu
    # -------------------------------------------------------------
    # click_link "Admin"
    # click_link "Organisations"
    # # Edit the first org in the table
    # find('table .dropdown-toggle').click
    # find('.dropdown-menu > li > a').click
    click_link "Admin Features"
    click_link "Organisations"
    first("td .dropdown button").click
    first(".dropdown-menu > li > a").click
    # -------------------------------------------------------------
    # end DMPTool customization
    # -------------------------------------------------------------

    nbr_links = all(".link").length
    add_link
    expect(all(".link").length).to eql(nbr_links + 1)
  end

  scenario "Super admin removes links" do
    # -------------------------------------------------------------
    # start DMPTool customization
    # DMPTool changed the label of the admin menu
    # -------------------------------------------------------------
    # click_link "Admin"
    # click_link "Organisations"
    # # Edit the first org in the table
    # find('table .dropdown-toggle').click
    # find('.dropdown-menu > li > a').click
    click_link "Admin Features"
    click_link "Organisations"
    first("td .dropdown button").click
    first(".dropdown-menu > li > a").click
    # -------------------------------------------------------------
    # end DMPTool customization
    # -------------------------------------------------------------

    add_link
    nbr_links = all(".link").length
    remove_link
    expect(all(".link").length).to eql(nbr_links - 1)
  end

end

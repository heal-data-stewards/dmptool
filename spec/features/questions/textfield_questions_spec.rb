# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Questions::Text Field questions" do

  include Webmocks

  before do
    @default_template  = create(:template, :default, :published)
    @phase             = create(:phase, template: @default_template)
    # Create a couple of Sections
    @section           = create(:section, phase: @phase)

    @question = create(:question, :textfield, section: @section)
    @user = create(:user)
    @plan = create(:plan, template: @default_template)
    create(:role, :creator, :editor, :commenter, user: @user, plan: @plan)

    stub_openaire
    sign_in_as_user(@user)
  end

  scenario "User answers a Text field question", :js do
    # Setup
    visit plan_path(@plan)

    # Action
    click_link "Write Plan"

    # Expectations
    expect(current_path).to eql(edit_plan_path(@plan))
    # 4 sections x 3 questions
    expect(page).to have_text("0/1 answered")

    # Action
    find("#section-panel-#{@section.id}").click
    # Fill in the answer form...
    within("#answer-form-#{@question.id}") do
      fill_in :answer_text, with: "My test answer"
      click_button "Save"
      sleep(0.2)
    end

    # Expectations
    expect(page).to have_text "Answered "
    expect(page).to have_text "1/1 answered"
    expect(Answer.where(question_id: @question.id)).to be_any
  end

end

# frozen_string_literal: true

class PlanExportsController < ApplicationController

  after_action :verify_authorized

  include ConditionsHelper

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def show
    @plan = Plan.includes(:answers, { template: { phases: { sections: :questions } } })
                .find(params[:plan_id])

    if privately_authorized? && export_params[:form].present?
      skip_authorization
      @show_coversheet          = export_params[:project_details].present?
      @show_sections_questions  = export_params[:question_headings].present?
      @show_unanswered          = export_params[:unanswered_questions].present?
      @show_custom_sections     = export_params[:custom_sections].present?
      @show_research_outputs    = export_params[:research_outputs].present?
      @show_related_identifiers = export_params[:related_identifiers].present?
      @formatting               = export_params[:formatting]
      @formatting               = @plan.settings(:export)&.formatting if @formatting.nil?
      @public_plan              = false

    elsif publicly_authorized?
      skip_authorization
      @show_coversheet          = true
      @show_sections_questions  = true
      @show_unanswered          = true
      @show_custom_sections     = true
      @show_research_outputs    = @plan.research_outputs&.any? || false
      @show_related_identifiers = @plan.related_identifiers&.any? || false
      @formatting               = @plan.settings(:export)&.formatting
      @formatting               = Settings::Template::DEFAULT_SETTINGS if @formatting.nil?
      @public_plan              = true

    else
      raise Pundit::NotAuthorizedError
    end

    @hash           = @plan.as_pdf(current_user, @show_coversheet)

    @selected_phase = if params.key?(:phase_id)
                        @plan.phases.find(params[:phase_id])
                      else
                        @plan.phases.order("phases.updated_at DESC")
                             .detect { |p| p.visibility_allowed?(@plan) }
                      end

    # Bug fix in the event that there was no phase with visibility_allowed
    unless @selected_phase.present?
      @selected_phase = @plan.phases.order("phases.updated_at DESC").first
    end

    respond_to do |format|
      format.html { show_html }
      format.csv  { show_csv }
      format.text { show_text }
      format.docx { show_docx }
      format.pdf  { show_pdf }
      format.json { show_json }
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def show_html
    render layout: false
  end

  def show_csv
    send_data @plan.as_csv(current_user, @show_sections_questions,
                           @show_unanswered,
                           @selected_phase,
                           @show_custom_sections,
                           @show_coversheet),
              filename: "#{file_name}.csv"
  end

  def show_text
    send_data render_to_string(partial: "shared/export/plan_txt"),
              filename: "#{file_name}.txt"
  end

  def show_docx
    # Using and optional locals_assign export_format
    render docx: "#{file_name}.docx",
           content: render_to_string(partial: "shared/export/plan",
                                     locals: { export_format: "docx" })
  end

  def show_pdf
    render pdf: file_name,
           margin: @formatting[:margin],
           footer: {
             center: _("Created using %{application_name}. Last modified %{date}") % {
               application_name: ApplicationService.application_name,
               date: l(@plan.updated_at.to_date, format: :readable)
             },
             font_size: 8,
             spacing: (Integer(@formatting[:margin][:bottom]) / 2) - 4,
             right: "[page] of [topage]",
             encoding: "utf8"
           }
  end

  def show_json
    json = render_to_string(partial: "/api/v2/plans/show",
                            locals: { plan: @plan, client: current_user })
    render json: "{\"dmp\":#{json}}"
  end

  def file_name
    # Sanitize bad characters and replace spaces with underscores
    ret = @plan.title
    Zaru.sanitize! ret
    ret = ret.strip.gsub(/\s+/, "_")
    ret = ret.gsub(/"/, "")
    # limit the filename length to 100 chars. Windows systems have a MAX_PATH allowance
    # of 255 characters, so this should provide enough of the title to allow the user
    # to understand which DMP it is and still allow for the file to be saved to a deeply
    # nested directory
    ret[0, 100]
  end

  def publicly_authorized?
    PublicPagePolicy.new(@plan, current_user).plan_organisationally_exportable? ||
      PublicPagePolicy.new(@plan).plan_export?
  end

  def privately_authorized?
    if current_user.present?
      PlanPolicy.new(current_user, @plan).export?
    else
      false
    end
  end

  def export_params
    params.require(:export)
          .permit(:form, :project_details, :question_headings, :unanswered_questions,
                  :custom_sections, :research_outputs, :related_identifiers,
                  formatting: [:font_face, :font_size, margin: %i[top right bottom left]])
  end

end

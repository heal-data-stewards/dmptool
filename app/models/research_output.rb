# frozen_string_literal: true

# == Schema Information
#
# Table name: research_outputs
#
#  id                      :bigint           not null, primary key
#  abbreviation            :string
#  access                  :integer          default("open"), not null
#  byte_size               :bigint
#  description             :text
#  display_order           :integer
#  is_default              :boolean
#  output_type             :integer          default("dataset"), not null
#  output_type_description :string
#  personal_data           :boolean
#  release_date            :datetime
#  sensitive_data          :boolean
#  title                   :string(255)      not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  license_id              :bigint
#  plan_id                 :integer
#
# Indexes
#
#  index_research_outputs_on_license_id   (license_id)
#  index_research_outputs_on_output_type  (output_type)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#  fk_rails_...  (license_id => licenses.id)
#
class ResearchOutput < ApplicationRecord

  include Identifiable
  include ValidationMessages

  enum output_type: %i[audiovisual collection data_paper dataset event image
                       interactive_resource model_representation physical_object
                       service software sound text workflow other]

  enum access: %i[open embargoed restricted closed]

  # ================
  # = Associations =
  # ================

  belongs_to :plan, optional: true, touch: true
  belongs_to :license, optional: true

  has_and_belongs_to_many :metadata_standards
  has_and_belongs_to_many :repositories

  # ===============
  # = Validations =
  # ===============

  validates_presence_of :output_type, :access, :title, message: PRESENCE_MESSAGE
  validates_uniqueness_of :title, { case_sensitive: false, scope: :plan_id,
                                    message: UNIQUENESS_MESSAGE }
  validates_uniqueness_of :abbreviation, { case_sensitive: false, scope: :plan_id,
                                           allow_nil: true, allow_blank: true,
                                           message: UNIQUENESS_MESSAGE }

  # Ensure presence of the :output_type_description if the user selected 'other'
  validates_presence_of :output_type_description, if: -> { other? }, message: PRESENCE_MESSAGE

  # ====================
  # = Instance methods =
  # ====================

  # Helper method to convert selected repository form params into Repository objects
  def repositories_attributes=(params)
    params.each do |_i, repository_params|
      repositories << Repository.find_by(id: repository_params[:id])
    end
  end

  # Helper method to convert selected metadata standard form params into MetadataStandard objects
  def metadata_standards_attributes=(params)
    params.each do |_i, metadata_standard_params|
      metadata_standards << MetadataStandard.find_by(id: metadata_standard_params[:id])
    end
  end

end

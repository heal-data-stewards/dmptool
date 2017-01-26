class AddForeignKeys < ActiveRecord::Migration
    # this migraiton modifies data in tables, and thus depends on being at a specific
    # point in the history of the codebase.  Specificly the models must reflect the
    # relationships expected within this code
  def change
    # remove broken references
    scrub_references
    # answers
    add_foreign_key :answers, :users
    add_foreign_key :answers, :plans
    add_foreign_key :answers, :questions

    # answers_question_options
    add_foreign_key :answers_question_options, :answers
    add_foreign_key :answers_question_options, :question_options

    # notes
    add_foreign_key :notes, :answers
    add_foreign_key :notes, :users

    # templates
    add_foreign_key :templates, :orgs

    # guidance_groups
    add_foreign_key :guidance_groups, :orgs

    # guidance_in_group
    add_foreign_key :guidance_in_group, :guidance_groups
    add_foreign_key :guidance_in_group, :guidances

    # guidances
    add_foreign_key :guidances, :guidance_groups

    # question_options
    add_foreign_key :question_options, :questions

    # org_token_permissions
    add_foreign_key :org_token_permissions, :orgs
    add_foreign_key :org_token_permissions, :token_permission_types

    # orgs
    add_foreign_key :orgs, :regions
    add_foreign_key :orgs, :languages

    # phases
    add_foreign_key :phases, :templates

    # plans
    add_foreign_key :plans, :templates

    # roles
    add_foreign_key :roles, :plans
    add_foreign_key :roles, :users

    # questions
    add_foreign_key :questions, :sections
    add_foreign_key :questions, :question_formats

    # questions_themes
    add_foreign_key :questions_themes, :questions
    add_foreign_key :questions_themes, :themes

    # sections
    add_foreign_key :sections, :phases

    # suggested_answers
    add_foreign_key :suggested_answers, :orgs
    add_foreign_key :suggested_answers, :questions

    # themes_in_guidance
    add_foreign_key :themes_in_guidance, :themes
    add_foreign_key :themes_in_guidance, :guidances

    # users
    add_foreign_key :users, :orgs
    add_foreign_key :users, :languages

    # users_perms
    add_foreign_key :users_perms, :users
    add_foreign_key :users_perms, :perms
  end

  def scrub_references
    # answers
    i = 0
    Answer.includes(:user, :plan, :question).find_each do |ans|
      if ans.user.nil? && ans.user_id.present?
        ans.user_id = nil
        i += 1
      end
      if ans.plan.nil? && ans.plan_id.present?
        ans.plan_id = nil
        i += 1
      end
      if ans.question.nil? && ans.question_id.present?
        ans.question_id = nil
        i += 1
      end
      ans.save!
    end
    puts "#{i} answers scrubbed"

    # notes
    i = 0
    Note.includes(:answer, :user).find_each do |note|
      if note.answer.nil? && note.answer_id.present?
        note.answer_id = nil
        i += 1
      end
      if note.user.nil? && note.user_id.present?
        note.user_id = nil
        i += 1
      end
      note.save!
    end
    puts "#{i} notes scrubbed"

    # templates
    i = 0
    Template.includes(:org).find_each do |temp|
      if temp.org.nil? && temp.org_id.present?
        temp.org_id = nil
        i += 1
      end
      temp.save!
    end
    puts "#{i} templates scrubbed"

    # guidance_groups
    # i = 0
    # GuidanceGroup.includes(:org).find_each do |gg|
    #   if gg.org.nil? && gg.org_id.present?
    #     gg.org_id = nil
    #     i += 1
    #   end
    #   gg.save!
    # end
    # puts "#{i} guidance groups scrubbed"

    # # question_options
    # i = 0
    # QuestionOption.includes(:question).find_each do |opt|
    #   if opt.question.nil? && opt.question_id.present?
    #     opt.question_id = nil
    #     i += 1
    #   end
    #   opt.save!
    # end
    # puts "#{i} question_options scrubbed"

    # # orgs
    # i = 0
    # Org.includes( :language).find_each do |org|
    #   if org.language.nil? && org.language_id.present?
    #     org.language_id = nil
    #     i += 1
    #   end
    #   org.save!
    # end
    # puts "#{i} orgs scrubbed"

    # # phases
    # # new structure so it's fine

    # # plans
    # # new structure so it's fine

    # roles
    i = 0
    Role.includes(:user, :plan).find_each do |role|
      if role.user.nil? && role.user_id.present?
        Role.delete_all(user_id: role.user_id)
        i += 1
        next
      end
      if role.plan.nil? && role.plan_id.present?
        Role.delete_all(plan_id: role.plan_id)
        i += 1
      end
    end
    puts "#{i} roles scrubbed"

    # # questions

    # # sections

    # # suggested_answers
    # i = 0
    # SuggestedAnswer.includes(:org, :question).find_each do |sa|
    #   if sa.org.nil? && sa.org_id.present?
    #     sa.org_id = nil
    #     i += 1
    #   end
    #   if sa.question.nil?
    #     sa.delete!
    #     i += 1
    #     next
    #   end
    #   sa.save!
    # end
    # puts "#{i} suggested answers scrubbed"

    # # themes_in_guidance

    # # users
    # i = 0
    # User.includes(:org, :language).find_each do |u|
    #   if u.org.nil? && u.org_id.present?
    #     u.org_id = nil
    #     i += 1
    #   end
    #   if u.language.nil? && u.language_id.present?
    #     u.language_id = nil
    #     i += 1
    #   end
    #   u.save!
    # end
    # puts "#{i} users scrubbed"

    # users_perms
    UsersPerm.includes(:user).all.each do |u|
      if u.user.nil?
        UsersPerm.delete_all(user_id: u.user_id)
      end
    end
  end
end
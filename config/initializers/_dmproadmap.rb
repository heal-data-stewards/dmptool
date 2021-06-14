# frozen_string_literal: true

require "csv"

# DMPRoadmap constants
#
# This file is a consolidation of the old custom configuration previously spread
# across the application.rb, branding.yml and the contact_us, devise, recaptcha,
# constants and wicked_pdf initializers
#
# It works in conjunction with the new Rails 5 config/credentials.yml.enc file
# for information on how to use the credentials file see:
#    https://medium.com/cedarcode/rails-5-2-credentials-9b3324851336
#
# This file's name begins with an underscore so that it is processed first and its
# values are available to all other initializers within this directory!
#
# DMPTool - Note that this file has become redundant now that we are using AnywayConfig
#           it currently acts as a bridge between the config/configs/dmproadmap_config.rb
#           and the baseline DMPRoadmap code. If we can convince DMPRoadmap to begin using
#           AnywayConfig then this file can be deleted and all of it's referenced variables
#           can be updated to point directly at the AnywayConfig file.
module DMPRoadmap

  class Application < Rails::Application

    # --------------------- #
    # ORGANISATION SETTINGS #
    # --------------------- #

    # Your organisation name, used in various places throught the application
    config.x.organisation.name = Rails.configuration.x.dmproadmap.organisation_name
    # Your organisation's abbreviation
    config.x.organisation.abbreviation = Rails.configuration.x.dmproadmap.organisation_abbreviation
    # Your organisation's homepage, used in some of the public facing pages
    config.x.organisation.url = Rails.configuration.x.dmproadmap.organisation_url
    # Your organisation's legal (official) name - used in the copyright portion of the footer
    config.x.organisation.copywrite_name = Rails.configuration.x.dmproadmap.organisation_copywrite_name
    # This email is used as the 'from' address for emails generated by the application
    config.x.organisation.email = Rails.configuration.x.dmproadmap.helpdesk_email
    # This email is used as the 'from' address for the feedback_complete email to users
    config.x.organisation.do_not_reply_email = Rails.configuration.x.dmproadmap.do_not_reply_email
    # This email is used in email communications
    config.x.organisation.helpdesk_email = Rails.configuration.x.dmproadmap.helpdesk_email
    # Your organisation's telephone number - used on the contact us page
    config.x.organisation.telephone = Rails.configuration.x.dmproadmap.organisation_phone
    # Your organisation's address - used on the contact us page
    # rubocop:disable Naming/VariableNumber
    config.x.organisation.address = {
      line_1: Rails.configuration.x.dmproadmap.organisation_address_line1,
      line_2: Rails.configuration.x.dmproadmap.organisation_address_line2,
      line_3: Rails.configuration.x.dmproadmap.organisation_address_line3,
      line_4: Rails.configuration.x.dmproadmap.organisation_address_line4,
      country: Rails.configuration.x.dmproadmap.organisation_country
    }
    # rubocop:enable Naming/VariableNumber

    # The Google maps link to your organisation's location - used to display the
    # Google map on the contact us page.
    # To find your organisation's Google maps URL, open maps.google.com, search for
    # your orgnaisation and then click the menu link to the left of the search box,
    # once the menu opens, click the 'share or embed' link and the 'embed' tab on
    # the dialog window that opens. DO NOT place the entire <iframe> tag below, just
    # the address!
    config.x.organisation.google_maps_link = Rails.configuration.x.dmproadmap.organisation_google_maps_link

    # Uncomment the following line if you want to redirect your users to an
    # organisational contact/help page instead of using the built-in contact_us form
    config.x.organisation.contact_us_url = Rails.configuration.x.dmproadmap.contact_us_url

    # -------------------- #
    # APPLICATION SETTINGS #
    # -------------------- #

    # Used throughout the system via ApplicationService.application_name
    config.x.application.name = Rails.configuration.x.dmproadmap.name
    # Used as the default domain when 'archiving' (aka anonymizing) a user account
    # for example `jane.doe@uni.edu` becomes `1234@removed_accounts-example.org`
    config.x.application.archived_accounts_email_suffix = Rails.configuration.x.dmproadmap.archived_accounts_email_suffix
    # Available CSV separators, the default is ','
    config.x.application.csv_separators = Rails.configuration.x.dmproadmap.csv_separators
    # The largest page size allowed in requests to the API (all versions)
    config.x.application.api_max_page_size = 100
    # The link to the API documentation - used in emails about the API
    config.x.application.api_documentation_urls = Rails.configuration.x.dmproadmap.api_documentation_urls
    # The links that appear on the home page. Add any number of links
    config.x.application.welcome_links = Rails.configuration.x.dmproadmap.welcome_links
    # The default user email preferences used when a new account is created
    config.x.application.preferences = Rails.configuration.x.dmproadmap.preferences
    # Setting to only take orgs from local and not allow on-the-fly creation
    config.x.application.restrict_orgs = Rails.configuration.x.dmproadmap.restrict_orgs
    # The location of the dmptool blog
    config.x.application.blog_rss = Rails.configuration.x.dmproadmap.blog_rss
    # Administrator emails
    config.x.application.admin_emails = Rails.configuration.x.dmproadmap.admin_emails

    # ------------------- #
    # SHIBBOLETH SETTINGS #
    # ------------------- #

    # Enable shibboleth as an alternative authentication method
    # Requires server configuration and omniauth shibboleth provider configuration
    # See config/initializers/devise.rb
    config.x.shibboleth.enabled = Rails.configuration.x.dmproadmap.shibboleth_enabled

    # Relative path to Shibboleth SSO Logouts
    config.x.shibboleth.login_url = Rails.configuration.x.dmproadmap.shibboleth_login_url
    config.x.shibboleth.logout_url = Rails.configuration.x.dmproadmap.shibboleth_logout_url

    # If this value is set to true your users will be presented with a list of orgs that have a
    # shibboleth identifier in the orgs_identifiers table. If it is set to false (default), the user
    # will be driven out to your federation's discovery service
    #
    # A super admin will also be able to associate orgs with their shibboleth entityIds if this is
    # set to true
    config.x.shibboleth.use_filtered_discovery_service = Rails.configuration.x.dmproadmap.shibboleth_use_filtered_discovery_service

    # ------- #
    # LOCALES #
    # ------- #

    # The default locale (use the i18n format!)
    config.x.locales.default = Rails.configuration.x.dmproadmap.locales_default
    # The character that separates a locale's ISO code for i18n. (e.g. `en-GB` or `en`)
    # Changing this value is not recommended!
    config.x.locales.i18n_join_character = Rails.configuration.x.dmproadmap.locales_i18n_join_character
    # The character that separates a locale's ISO code for Gettext. (e.g. `en_GB` or `en`)
    # Changing this value is not recommended!
    config.x.locales.gettext_join_character = Rails.configuration.x.dmproadmap.locales_gettext_join_character

    # ---------- #
    # THRESHOLDS #
    # ---------- #

    # Determines the number of links a funder is allowed to add to their template
    config.x.max_number_links_funder = Rails.configuration.x.dmproadmap.max_number_links_funder
    # Maximum number of links to display for an Org
    config.x.max_number_links_org = Rails.configuration.x.dmproadmap.max_number_links_org
    # Determines the number of links a funder can add for sample plans for their template
    config.x.max_number_links_sample_plan = Rails.configuration.x.dmproadmap.max_number_links_sample_plan
    # Determines the maximum number of themes to display per column when an org admin
    # updates a template question or guidance
    config.x.max_number_themes_per_column = Rails.configuration.x.dmproadmap.max_number_themes_per_column
    # default results per page
    config.x.results_per_page = Rails.configuration.x.dmproadmap.results_per_page

    # ------------- #
    # PLAN DEFAULTS #
    # ------------- #

    # The default visibility a plan receives when it is created.
    # options: 'privately_visible', 'organisationally_visible' and 'publicly_visibile'
    config.x.plans.default_visibility = Rails.configuration.x.dmproadmap.plans_default_visibility

    # The percentage of answers that have been filled out that determine if a plan
    # will be marked as complete. Plan completion has implications on whether or
    # not plan visibility settings are editable by the user and whether or not the
    # plan can be submitted for feedback
    config.x.plans.default_percentage_answered = Rails.configuration.x.dmproadmap.plans_default_percentage_answered

    # Whether or not Super adminis can read all of the user's plans regardless of
    # the plans visibility and whether or not the plan has been shared
    config.x.plans.org_admins_read_all = Rails.configuration.x.dmproadmap.plans_org_admins_read_all
    # Whether or not Organisational administrators can read all of the user's plans
    # regardless of the plans visibility and whether or not the plan has been shared
    config.x.plans.super_admins_read_all = Rails.configuration.x.dmproadmap.plans_super_admins_read_all

    # Specify a list of the preferred licenses types. These licenses will appear in a select
    # box on the 'Research Outputs' tab when editing a plan along with the option to select
    # 'other'. When 'other' is selected, the user is presented with the full list of licenses.
    #
    # The licenses will appear in the order you specify here.
    #
    # Note that the values you enter must match the :identifier field of the licenses table.
    # You can use the `%{latest}` markup in place of version numbers if desired.
    config.x.preferred_licenses = Rails.configuration.x.dmproadmap.preferred_licenses
    # Link to external guidance about selecting one of the preferred licenses. A default
    # URL will be displayed if none is provided here. See app/views/research_outputs/licenses/_form
    config.x.preferred_licenses_guidance_url = Rails.configuration.x.dmproadmap.preferred_licenses_guidance_url

    # The default user email preferences used when a new account is created
    config.x.application.preferences = Rails.configuration.x.dmproadmap.preferences

    # ---------------------------------------------------- #
    # CACHING - all values are in seconds (86400 == 1 Day) #
    # ---------------------------------------------------- #

    # Determines how long to cache results for OrgSelection::SearchService
    config.x.cache.org_selection_expiration = Rails.configuration.x.dmproadmap.cache_org_selection_expiration
    # Determines how long to cache results for the ResearchProjectsController
    config.x.cache.research_projects_expiration = Rails.configuration.x.dmproadmap.cache_research_projects_expiration

    # ---------------- #
    # Google Analytics #
    # ---------------- #
    # this is the abbreviation for the installation's root org as set in the org table
    config.x.google_analytics.tracker_root = Rails.configuration.x.dmproadmap.google_analytics_tracker_root

    # ------------------------------------------------------------------------ #
    # reCAPTCHA - recaptcha appears on the create account and contact us forms #
    # ------------------------------------------------------------------------ #
    config.x.recaptcha.enabled = Rails.configuration.x.dmproadmap.recaptcha_enabled

    # ----------- #
    # DOI Minting
    # ----------- #
    config.x.allow_doi_minting = Rails.configuration.x.dmproadmap.doi_minting

    # ----- #
    # ORCID #
    # ----- #
    config.x.orcid_landing_page_url = Rails.configuration.x.dmproadmap.orcid_landing_page_url
    config.x.orcid_api_base_url = Rails.configuration.x.dmproadmap.orcid_api_base_url
  end

end

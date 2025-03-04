# frozen_string_literal: true

require "httparty"
require "rss"

module Dmptool

  module HomeController

    def render_home_page
      # Usage stats
      @stats = statistics

      # Top 5 templates
      @top_five = top_templates

      # Retrieve/cache the DMPTool blog's latest posts
      @rss = feed

      render "home/index"
    end

    private

    # Collect general statistics about the application
    def statistics
      cached = Rails.cache.read("stats")
      return cached unless cached.nil?

      stats = {
        user_count: User.select(:id).count,
        completed_plan_count: Plan.select(:id).count,
        institution_count: Org.participating.select(:id).count
      }
      cache_content("stats", stats)
      stats
    end

    # Collect  the list of the top 5 most used templates for the past 90 days
    def top_templates
      cached = Rails.cache.read("top_five")
      return cached unless cached.nil?

      end_date = Date.today
      start_date = (end_date - 90)
      ids = Plan.group(:template_id)
                .where(created_at: start_date..end_date)
                .order("count_id DESC")
                .count(:id).keys

      top_five = Template.where(id: ids[0..4])
                         .pluck(:title)
      cache_content("top_five", top_five)
      top_five
    end

    # Get the last 5 blog posts
    def feed
      cached = Rails.cache.read("rss")
      return cached unless cached.nil?

      resp = HTTParty.get(Rails.configuration.x.application.blog_rss)
      return [] unless resp.code == 200

      rss = RSS::Parser.parse(resp.body, false).items.first(5)
      cache_content("rss", rss)
      rss
    rescue StandardError => e
      # If we were unable to connect to the blog rss
      logger.error("Caught exception RSS parse: #{e}.")
      []
    end

    # Store information in the cache
    def cache_content(type, data)
      return nil unless type.present?

      Rails.cache.write(type, data, expires_in: 60.minutes)
    rescue StandardError => e
      logger.error("Unable to add #{type} to the Rails cache: #{e}.")
    end

  end

end

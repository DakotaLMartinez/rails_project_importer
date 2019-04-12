require 'open-uri'
require 'typhoeus'

class ProjectImporter 
  BASE_URL = 'https://learn.co/api/v1/live_reviews'
  WANTED_KEYS = [
    "id",
    "status",
    "github_url",
    "blog_url",
    "video_url"
  ]

  attr_reader :batch
  def initialize(batch)
    @batch = batch
  end

  def fetch
    fetch_unscheduled.concat(fetch_pending).concat(fetch_completed)
  end

  def fetch_unscheduled
    json = JSON.parse(Typhoeus.get("#{BASE_URL}/unscheduled?iteration=#{batch.iteration}").try(:response_body))
    filter_params(json)
  end

  def fetch_pending
    json = JSON.parse(Typhoeus.get("#{BASE_URL}/pending_feedback?iteration=#{batch.iteration}").try(:response_body))
    filter_params(json)
  end

  def fetch_completed
    json = JSON.parse(Typhoeus.get("#{BASE_URL}/complete?iteration=#{batch.iteration}").try(:response_body))
    filter_params(json)
  end

  def filter_params(hashed_json)
    hashed_json.map do |hash|
      hash.select{|k,v| WANTED_KEYS.include?(k)}.merge({
        "student_email" => hash["student"]["email"],
        "project_type" => hash["lesson"]["title"]
      })
    end
  end
end
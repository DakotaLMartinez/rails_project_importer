require 'open-uri'
require 'typhoeus'

class ProjectImporter 
  BASE_URL = 'https://learn.co/api/v1/live_reviews'
  WANTED_KEYS = [
    "id",
    "status",
    "github_url",
    "blog_url",
    "video_url",
    "created_at"
  ]

  attr_reader :batch
  def initialize(batch=nil)
    @batch = batch
  end

  def query_params
    batch ? "?iteration=#{batch.iteration}" : ""
  end

  def fetch
    if batch 
      fetch_unscheduled.concat(fetch_pending).concat(fetch_completed)
    else
      fetch_unscheduled.concat(fetch_pending)
    end
  end

  def fetch_unscheduled
    json = JSON.parse(Typhoeus.get("#{BASE_URL}/unscheduled#{query_params}").try(:response_body))
    filter_params(json)
  end

  def fetch_pending
    json = JSON.parse(Typhoeus.get("#{BASE_URL}/pending_feedback#{query_params}").try(:response_body))
    filter_params(json)
  end

  def fetch_completed
    json = JSON.parse(Typhoeus.get("#{BASE_URL}/complete#{query_params}").try(:response_body))
    filter_params(json)
  end

  def filter_params(hashed_json)
    hashed_json.map do |hash|
      hash.select{|k,v| WANTED_KEYS.include?(k)}.merge({
        "student_info" => {
          "active_batch_id" => hash["student"]["active_batch_id"],
          "email" => hash["student"]["email"],
          "full_name" => hash["student"]["full_name"],
          "github_username" => hash["student"]["github_username"]
        },
        "project_type" => hash["lesson"]["title"],
        "portfolio_project_id" => hash["id"]
      })
    end
  end
end
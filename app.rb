# app.rb
require 'sinatra'
require 'rdf'
require 'rdf/turtle'
require_relative './ai_risk_assessment'

set :bind, '0.0.0.0'
set :port, 4567

get '/' do
  @allowed = ALLOWED_VALUES
  erb :form
end

post '/submit' do
  responses = {
    domain: params[:domain],
    purpose: params[:purpose],
    capability: params[:capability],
    deployer: params[:deployer],
    subject: params[:subject]
  }

  scores = {
    domain: score_domain(responses[:domain]),
    purpose: score_purpose(responses[:purpose]),
    capability: score_capability(responses[:capability]),
    deployer: score_deployer(responses[:deployer]),
    subject: score_subject(responses[:subject])
  }

  total = scores.values.sum
  level = calculate_risk_level(total)

  generate_markdown(responses, scores, total, level)
  generate_rdf(responses, scores, total, level)

  redirect '/report'
end

get '/report' do
  @markdown = File.read("assessment_report.md")
  erb "<pre><%= @markdown %></pre>"
end

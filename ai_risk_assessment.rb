#!/usr/bin/env ruby

require 'rdf'
require 'rdf/turtle'

# Define the AIRO namespace
AIRO = RDF::Vocabulary.new("http://example.org/airo#")

# Allowed values for inputs
ALLOWED_VALUES = {
  domain: [
    "Employment",
    "Education",
    "Law Enforcement",
    "Migration",
    "Critical Infrastructure",
    "Access to Essential Services",
    "Justice",
    "Democratic Processes"
  ],
  purpose: [
    "Recruitment",
    "Credit Scoring",
    "Insurance Underwriting",
    "Criminal Risk Assessment",
    "Border Control",
    "Public Service Allocation"
  ],
  capability: [
    "Biometric Identification",
    "Emotion Recognition",
    "Predictive Analytics",
    "Natural Language Processing",
    "Computer Vision"
  ],
  deployer: [
    "Government Agency",
    "Private Company",
    "Non-Profit Organization",
    "Academic Institution"
  ],
  subject: [
    "Employees",
    "Students",
    "Citizens",
    "Migrants",
    "Consumers"
  ]
}

# ---------------------
# 1. Questionnaire
# ---------------------
def generate_questionnaire
  questionnaire = <<~Q
    AI Risk Assessment Questionnaire
    Please answer the following questions using one of the allowed values.

    1. In which domain is the AI system used?
       Allowed values: #{ALLOWED_VALUES[:domain].join(', ')}
       Answer:

    2. What is the purpose of the AI system?
       Allowed values: #{ALLOWED_VALUES[:purpose].join(', ')}
       Answer:

    3. What is the capability of the AI system?
       Allowed values: #{ALLOWED_VALUES[:capability].join(', ')}
       Answer:

    4. Who is the deployer of the AI system?
       Allowed values: #{ALLOWED_VALUES[:deployer].join(', ')}
       Answer:

    5. Who is the AI subject?
       Allowed values: #{ALLOWED_VALUES[:subject].join(', ')}
       Answer:
  Q

  puts questionnaire
end

# ---------------------
# 2. Risk Scoring Logic
# ---------------------
def score_domain(val)
  case val
  when "Law Enforcement", "Migration", "Justice"
    3
  when "Employment", "Education", "Access to Essential Services"
    2
  else
    1
  end
end

def score_purpose(val)
  case val
  when "Criminal Risk Assessment", "Border Control"
    3
  when "Credit Scoring", "Insurance Underwriting"
    2
  else
    1
  end
end

def score_capability(val)
  case val
  when "Biometric Identification", "Emotion Recognition"
    3
  when "Computer Vision", "Predictive Analytics"
    2
  else
    1
  end
end

def score_deployer(val)
  case val
  when "Government Agency", "Private Company"
    2
  else
    1
  end
end

def score_subject(val)
  case val
  when "Migrants", "Citizens"
    3
  when "Students", "Employees"
    2
  else
    1
  end
end

def calculate_risk_level(score)
  case score
  when 13..15 then "HIGH"
  when 9..12  then "MEDIUM"
  else "LOW"
  end
end

# ---------------------
# 3. Parse and Score
# ---------------------
def parse_responses(file_path)
  responses = {}
  current = nil

  File.readlines(file_path).each do |line|
    line.strip!
    next if line.empty?

    current = :domain if line =~ /^1\./
    current = :purpose if line =~ /^2\./
    current = :capability if line =~ /^3\./
    current = :deployer if line =~ /^4\./
    current = :subject if line =~ /^5\./

    if line.start_with?("Answer:") && current
      value = line.sub("Answer:", "").strip
      unless ALLOWED_VALUES[current].include?(value)
        puts "Invalid value for #{current}: #{value}"
        exit(1)
      end
      responses[current] = value
    end
  end

  responses
end

# ---------------------
# 4. Markdown Report
# ---------------------
def generate_markdown(responses, scores, total, level)
  markdown = <<~MD
    # AI Risk Assessment Report

    ## Answers

    | Dimension | Value | Risk Score |
    |-----------|--------|------------|
    | Domain    | #{responses[:domain]} | #{scores[:domain]} |
    | Purpose   | #{responses[:purpose]} | #{scores[:purpose]} |
    | Capability| #{responses[:capability]} | #{scores[:capability]} |
    | Deployer  | #{responses[:deployer]} | #{scores[:deployer]} |
    | Subject   | #{responses[:subject]} | #{scores[:subject]} |

    **Total Risk Score:** #{total}  
    **Overall Risk Level:** #{level}
  MD

  File.write("assessment_report.md", markdown)
  puts "Generated: assessment_report.md"
end

# ---------------------
# 5. RDF Output
# ---------------------
def generate_rdf(responses, scores, total, level)
  graph = RDF::Graph.new
  system_uri = RDF::URI("http://example.org/ai_system/1")

  graph << [system_uri, RDF.type, AIRO.AISystem]
  responses.each { |k, v| graph << [system_uri, AIRO.send("has#{k.capitalize}"), v] }

  graph << [system_uri, AIRO.hasTotalRiskScore, total]
  graph << [system_uri, AIRO.hasRiskLevel, level]

  RDF::Turtle::Writer.open("assessment_report.ttl") { |w| w << graph }
  puts "Generated: assessment_report.ttl"
end

# ---------------------
# Main
# ---------------------
if __FILE__ == $0
  if ARGV.empty?
    puts "Usage:"
    puts "  ruby ai_risk_assessment.rb generate_questionnaire"
    puts "  ruby ai_risk_assessment.rb process_responses questionnaire.txt"
    exit
  end

  case ARGV[0]
  when "generate_questionnaire"
    generate_questionnaire
  when "process_responses"
    file = ARGV[1]
    unless file && File.exist?(file)
      puts "Provide a valid questionnaire file."
      exit
    end

    responses = parse_responses(file)
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
  else
    puts "Unknown command."
  end
end

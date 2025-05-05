# AI Risk Assessment Tool

This project evaluates the risk of an AI system using principles from the [AIRO Ontology](https://delaramglp.github.io/airo/). It supports **command-line** and **web-based (Sinatra)** interfaces and outputs results in both **Markdown** and **RDF/Turtle** formats.

---

## Features

- Collects AI risk inputs via a structured questionnaire.
- Applies heuristic risk scoring logic.
- Outputs:
  - Human-readable **Markdown Report**
  - **RDF/Turtle** data for SPARQL/linked data applications
- Available as a CLI tool or web app (Sinatra).

---

## Installation

```bash
git clone https://github.com/inloopstudio/AI-Risk-Ontology-AIRO.git
cd AI-Risk-Ontology-AIRO
bundle install
```

---

## Usage

### 1. Command-Line

#### Generate questionnaire:

```bash
 bundle exec ruby ai_risk_assessment.rb generate_questionnaire > questionnaire.txt
```

#### Fill `questionnaire.txt`, then:

```bash
 bundle exec ruby ai_risk_assessment.rb process_responses questionnaire.txt
```

Outputs:

* `assessment_report.md`
* `assessment_report.ttl`

---

### 2. Web Application

Start the Sinatra server:

```bash
bundle exec ruby app.rb
```

Visit `http://localhost:4567`, fill out the form, and get your AI Risk Report in Markdown.

---

### 3. Replit Deployment

The app is avaible to remix at https://replit.com/@inloop/AI-Risk-Ontology-AIRO 

---

## Output Formats

### Markdown

```
# AI Risk Assessment Report
...
**Total Risk Score:** 13  
**Overall Risk Level:** HIGH
```

### RDF/Turtle

```turtle
@prefix airo: <http://example.org/airo#> .

<http://example.org/ai_system/1>
  a airo:AISystem ;
  airo:hasDomain "Law Enforcement" ;
  ...
  airo:hasRiskLevel "HIGH" .
```

---

## Sponsors

This project is sponsored by [inloop.studio](https://inloop.studio)



## License
MIT




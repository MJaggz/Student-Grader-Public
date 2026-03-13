class Course < ApplicationRecord
  has_many :sections, dependent: :destroy
  scope :cse_subject, -> { where("UPPER(subject) = ?", "CSE") }
  after_update :sync_data_to_sections

  validates :title, presence: true
  validates :subject, presence: true
  validates :catalog_number, presence: true
  validates :units, presence: true
  validates :academic_career, presence: true
  validates :academic_group, presence: true
  validates :campus, presence: true
  validates :component, presence: true
  validates :description, presence: true

  def self.reload_from_api(api_params)
    url = "https://contenttest.osu.edu/v2/classes/search"
    
    # Ensure defaults are set
    api_params[:q] = ""
    api_params[:subject] = "cse"
    api_params[:client] ||= "class-search-ui"
    
    # Track stats
    total_saved = 0
    current_page = 1
    total_pages = 1

    puts "--- STARTING OSU API ---"

    while current_page <= total_pages
      api_params[:p] = current_page
      puts "DEBUG: Full API URL: #{url}?#{api_params.to_query}"
      response = HTTParty.get(url, query: api_params)
    

      if response.success?
        data = response.parsed_response.dig('data') || {}
        courses_list = data.dig('courses') || []
        
        total_pages = data.dig('totalPages').to_i
        total_pages = 1 if total_pages < 1

        courses_list.each do |api_data|
          data = api_data["course"] || {}
          next unless data["subject"].to_s.casecmp("CSE").zero?

          course = upsert_course(api_data, api_params)
        
          sync_sections_for_course(course, api_data["sections"] || [])
          
          total_saved += 1
        end
        
        current_page += 1
      else
        puts "API Error: #{response.code}"
        break
      end
    end

    if total_saved > 0
      stale = Course.where(term: api_params[:term], campus: api_params[:campus])
      stale.destroy_all
    end

    return total_saved
  end

  private

  def self.upsert_course(api_data, api_params)
    data = api_data["course"] || {}
    
    course = Course.find_or_initialize_by(
      subject: data["subject"],
      catalog_number: data["catalogNumber"],
      term: data["term"],
      campus: data["campus"]
    )

    course.update!(
      academic_career: data["academicCareer"],
      academic_group: data["academicGroup"],
      component: data["component"],
      description: data["description"],
      title: data["title"],
      units: data["minUnits"].to_s
    )
    course
  end

  def sync_data_to_sections
    if saved_change_to_term? || saved_change_to_units? || saved_change_to_component? || saved_change_to_campus?
      sections.update_all(
        term: term, 
        credit_hours: units, 
        instruction_mode: component
      )
    end
  end

  def self.sync_sections_for_course(course, api_sections)
    seen_section_ids = []

    api_sections.each do |api_section|
      section = course.sections.find_or_initialize_by(class_number: api_section["classNumber"])
      
      meeting = api_section["meetings"]&.first || {}
      days = []
      days << "M" if meeting["monday"]
      days << "T" if meeting["tuesday"]
      days << "W" if meeting["wednesday"]
      days << "Th" if meeting["thursday"]
      days << "F" if meeting["friday"]
      
      formatted_days = days.any? ? days.join(" ") : "TBA"
      formatted_times = meeting["startTime"].present? ? "#{meeting["startTime"]} to #{meeting["endTime"]}" : "TBA"
      meeting_location = meeting["buildingDescription"]
      credit_hours = course.units
      instruction_mode = api_section["instructionMode"]

      section.update!(
        term: api_section["term"],
        days: formatted_days,
        times: formatted_times,
        location: meeting_location,
        credit_hours: credit_hours,
        instruction_mode: instruction_mode
      )
      seen_section_ids << section.id
    end

    course.sections.where.not(id: seen_section_ids).destroy_all
  end
end


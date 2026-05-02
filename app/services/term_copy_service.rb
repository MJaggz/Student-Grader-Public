class TermCopyService
  Result = Struct.new(
    :success?,
    :message,
    :sections_copied,
    :grader_requests_copied,
    :target_term,
    keyword_init: true
  )

  def initialize(source_term:, target_term:, actor:)
    @source_term = source_term.to_s.strip
    @target_term = target_term.to_s.strip
    @actor = actor
  end

  def call
    return failure("Select both a source term and a target term.") if source_term.blank? || target_term.blank?
    return failure("Source and target terms must be different.") if source_term == target_term
    return failure("No sections were found for the selected source term.") if source_sections.none?
    return failure("Target term #{target_term} already has sections. Copy cancelled to avoid overwriting existing setup.") if target_sections_exist?

    sections_copied = 0
    grader_requests_copied = 0

    ActiveRecord::Base.transaction do
      source_sections.each do |source_section|
        new_section = build_target_section(source_section)
        new_section.save!
        sections_copied += 1

        next unless source_section.grader_request.present?

        new_section.create_grader_request!(
          request_number: generate_request_number(new_section),
          requestor_name: actor_identifier,
          request_date: Time.current,
          fulfilled_date: nil,
          num_graders_requested: new_section.graders_required,
          num_graders_assigned: 0
        )
        grader_requests_copied += 1
      end
    end

    Result.new(
      success?: true,
      message: "Term setup copied successfully.",
      sections_copied: sections_copied,
      grader_requests_copied: grader_requests_copied,
      target_term: target_term
    )
  rescue ActiveRecord::RecordInvalid => e
    failure("Copy failed: #{e.record.errors.full_messages.to_sentence}")
  end

  private

  attr_reader :source_term, :target_term, :actor

  def source_sections
    @source_sections ||= Section.includes(:grader_request).where(term: source_term).order(:course_id, :section_number)
  end

  def target_sections_exist?
    Section.where(term: target_term).exists?
  end

  def build_target_section(source_section)
    source_section.course.sections.new(
      term: target_term,
      section_number: source_section.section_number,
      class_number: nil,
      days: source_section.days,
      times: source_section.times,
      location: source_section.location,
      credit_hours: source_section.credit_hours,
      instruction_mode: source_section.instruction_mode,
      graders_required: source_section.graders_required
    )
  end

  def actor_identifier
    actor&.email.presence || "term-copy"
  end

  def generate_request_number(section)
    "#{section.section_number}-#{target_term}-#{SecureRandom.hex(2)}"
  end

  def failure(message)
    Result.new(
      success?: false,
      message: message,
      sections_copied: 0,
      grader_requests_copied: 0,
      target_term: target_term
    )
  end
end

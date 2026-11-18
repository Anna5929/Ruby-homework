require 'date'

class Expense
  CATEGORIES = %w[food transport study entertainment other].freeze

  attr_reader :id, :date, :amount_in_kopecks, :category, :description

  def initialize(id:, date:, amount_in_kopecks:, category:, description:)
    validate_id(id)
    self.class.validate_date(date)
    validate_amount(amount_in_kopecks)
    validate_category(category)
    validate_description(description)

    @id = id
    @date = date
    @amount_in_kopecks = amount_in_kopecks
    @category = category
    @description = description.strip
  end

  def self.validate_date(date)
    unless date.is_a?(String) && date.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      raise ArgumentError, "Дата повинна мати формат YYYY-MM-DD."
    end

    begin
      Date.iso8601(date)
    rescue Date::Error
      raise ArgumentError, "Вказано неіснуючу календарну дату."
    end
  end

  private

  def validate_id(id)
    unless id.is_a?(Integer) && id.positive?
      raise ArgumentError, "ID має бути додатним цілим числом."
    end
  end

  def validate_amount(amount)
    unless amount.is_a?(Integer) && amount.positive?
      raise ArgumentError, "Сума має бути додатним цілим числом копійок."
    end
  end

  def validate_category(category)
    unless CATEGORIES.include?(category)
      raise ArgumentError, "Недопустима категорія витрати."
    end
  end

  def validate_description(description)
    unless description.is_a?(String)
      raise ArgumentError, "Опис має бути текстом."
    end

    text = description.strip

    if text.empty? || text.length > 200
      raise ArgumentError, "Опис повинен містити від 1 до 200 символів."
    end
  end
end

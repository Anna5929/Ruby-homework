require "json"

module Inventory
  class Error < StandardError; end
  class ReadError < Error; end
  class DataError < Error; end

  def self.load(path)
    text = File.read(path)
    products = JSON.parse(text)

    raise DataError, "Корінь JSON повинен бути масивом" unless products.is_a?(Array)

    products.each_with_index do |product, index|
      number = index + 1

      unless product.is_a?(Hash)
        raise DataError, "Запис #{number}: повинен бути об'єктом"
      end

      name = product["name"]
      price = product["price_in_kopecks"]
      quantity = product["quantity"]

      unless name.is_a?(String) && !name.strip.empty?
        raise DataError, "Запис #{number}: некоректна назва товару"
      end

      unless price.is_a?(Integer) && price >= 0
        raise DataError, "Запис #{number}: некоректна ціна"
      end

      unless quantity.is_a?(Integer) && quantity >= 0
        raise DataError, "Запис #{number}: некоректна кількість"
      end
    end

    products
  rescue Errno::ENOENT
    raise ReadError, "Не вдалося знайти файл: #{path}"
  rescue JSON::ParserError => e
    raise DataError, "Некоректний JSON: #{e.message}"
  end

  def self.total(products)
    products.sum do |product|
      product["price_in_kopecks"] * product["quantity"]
    end
  end
end

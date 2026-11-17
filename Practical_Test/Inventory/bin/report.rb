require_relative "../lib/inventory"

path = ARGV.first || File.expand_path("../data/products.json", __dir__)

begin
  products = Inventory.load(path)
  total_kopecks = Inventory.total(products)

rescue Inventory::ReadError => e
  warn "Помилка читання: #{e.message}"
  exit 3

rescue Inventory::DataError => e
  warn "Помилка даних: #{e.message}"
  exit 2

else
  hryvnias = total_kopecks / 100
  kopecks = total_kopecks % 100

  puts format("%d.%02d грн", hryvnias, kopecks)
end

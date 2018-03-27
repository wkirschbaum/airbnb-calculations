require 'csv'
require 'byebug'

keys = CSV.read(Dir['./*.csv'].first).first
data = []
Dir['./*.csv'].reduce([]) do |col, file| 
  CSV.read(file)
  CSV.read(file).each_with_index do |row, index| 
    if index > 0
      data << { date: Date.strptime(row[0],"%m/%d/%Y"), amount: Float(row[10]), listing: row[6] }
    end
  end
end
  
periods = {}
[Date.new(2017, 3, 1), Date.new(2018, 3, 1), Date.new(2019, 3, 1)].each do |date|
  periods[date.strftime("%d %B %Y")], data = data.partition { |e| e[:date] < date }
end

periods.each do |k, v| 
  puts "Net income to before #{k}"
  puts "R#{v.sum { |k| k[:amount] }}"
  puts ""
end

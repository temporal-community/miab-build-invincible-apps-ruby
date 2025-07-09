def sleep_seconds(seconds)
    sleep(seconds)
end
  
def main
    (1..10).each do |i|
      puts i
      sleep_seconds(1)
    end
end
  
begin
    main
rescue StandardError => error
    puts "An error occurred: #{error}"
end
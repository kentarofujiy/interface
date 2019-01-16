require 'tty-prompt'
require 'tty-file'
require 'json'
require 'active_support/inflector'
require 'tty-box'
require 'pastel'
require 'tty-table'
require 'tty-command'

cmd = TTY::Command.new
#result = cmd.run('ls -d /*')
#result.each do |line|
#  list =  puts "line #{line},"
#end
#lista = [result.each {|t|   "eu"}]
#lista = Array.new
#lista = result.to_a
#print lista
# puts result
 #list.each  { |a| puts a}
 #puts = list.to_s
#[1, 2, 3, 4].flat_map { |e| [e, -e] } #=> [1, -1, 2, -2, 3, -3, 4, -4]


#out, err = cmd.run('git status')
#puts "Result: #{out}"

 cmd.run('ls ..') do |out, err|
   if out =~ /.*shoes*/
     puts "Result: #{out}"
     puts 'igual a master'
   else
      cmd.run!('ls') do |out, err|
         if out =~ /.*teste*/
         puts "Result: #{out}"
          puts 'passou nested'
   else
      puts "else da nested"
   end

 end
   end

 end
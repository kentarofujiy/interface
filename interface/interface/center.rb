require 'tty-prompt'
require 'tty-file'
require 'json'
require 'active_support/inflector'
require 'tty-box'
require 'pastel'
require 'tty-table'
require 'tty-command'




print TTY::Cursor.clear_screen

box_1 = TTY::Box.frame(
  #top: 2,
  #left: 10,
  width: 100,
  height: 20,
  border: :thick,
  align: :center,
  padding: 3,
  title: {
    top_left: ' MANACA DIGITAL - PROJETO TARDIS | AUTOMATION 2019 '
  },
  style: {
    fg: :bright_yellow,
    bg: :blue,
    border: {
      fg: :bright_yellow,
      bg: :blue
    }
  }
) do
  "ADICIONAR CAMPO A UM SCAFFOLD EXISTENTE \n
  ######################################## \n
  Certifique-se que o path para o projeto  \n
  esteja setado corretamente.              \n
  ######################################## \n
  No próximo passo indique o nome do model \n
  a ser alterado, no singular, o nome e    \n
  tipo do campo.                           \n
  ######################################## \n
  A automação vai gera a migração e        \n
  alterar os arquivos e templates.         \n
  "
end

puts box_1
print "\n" * 5

cmd = TTY::Command.new
result = cmd.run(:ls, '-1')
result.each { |line| puts line }
#out, err = cmd.run('git status')
#puts "Result: #{out}"

# cmd.run('git status') do |out, err|
#   if out =~ /.*On branch master*/
#     puts "Result: #{out}"
#     puts 'igual a master'
#   else
#      cmd.run!('git log') do |out, err|
#         if out =~ /.*On branch master*/
#         puts "Result: #{out}"
#          puts 'passou nested'
#   else
#      puts "else da nested"
#   end

# end
#   end

# end



prompt = TTY::Prompt.new(prefix: '[?] ')

result = prompt.collect do
  key(:modelName).ask('Nome do Model')
  key(:columnName).ask('Nome da Coluna')
  key(:columnType).select("Tipo da coluna:", %w(integer string text float boolean datetime), cycle: true)
end

    #RETORNA OS DADOS
dados = JSON.generate(result)
    #MODEL
_modelName = JSON.parse(dados)['modelName']            # => model
modelName = JSON.parse(dados)['modelName']             # => model
_modelNameCode = JSON.parse(dados)['modelName']        # => model
_modelNameMigration = _modelName.capitalize            # => Model
modelNameMigration = _modelNameMigration.pluralize     # => Models
modelNamePlural = _modelName.pluralize                 # => models
modelNameCode = _modelNameCode.prepend(":")            # => :model
    #NOME
_columnName = JSON.parse(dados)['columnName']          # => column
columnName = JSON.parse(dados)['columnName']           # => column
_columnNameCode = JSON.parse(dados)['columnName']      # => column
columnNameMigration = _columnName.capitalize           # => Column
columnNameCode = _columnNameCode.prepend(":")          # => :column
    #TYPE
_columnType = JSON.parse(dados)['columnType']
columnType = JSON.parse(dados)['columnType']
columnTypeCode = _columnType.prepend(":")
    #PATHS
controllerFileName = "../server-conheca/app/controllers/#{modelNamePlural}_controller.rb"
viewFormPath = "../server-conheca/app/views/#{modelNamePlural}/_form.html.erb"
viewShowPath = "../server-conheca/app/views/#{modelNamePlural}/show.html.erb"
    #COMMANDOS
migrationCommand = "Add#{columnNameMigration}To#{modelNameMigration} #{columnName}#{columnTypeCode}"
    #TEMPLATES
#Template do formulário:
    #String, integral e float
formGeneralTemplate = "<div class='form-group'><div class='control-label col-sm-2'><%= form.label #{columnNameCode} %></div><div class='col-sm-8'><%= form.text_field #{columnNameCode}, id: #{columnNameCode}, class: 'form-control', placeholder: '#{modelName}' %></div></div>"
    #text
formTextTemplate = "<div class='form-group'><div class='control-label col-sm-2'><%= form.label #{columnNameCode} %></div><div class='col-sm-8'><%= form.text_area #{columnNameCode}, id: #{columnNameCode}, class: 'form-control', rows: 10 %></div></div>"
    #Boolean
formBoolTemplate = "<div class='form-group'><div class='control-label col-sm-2'><%= form.label #{columnNameCode} %></div><div class='col-sm-8'><%= form.text_area #{columnNameCode}, id: #{columnNameCode}, class: 'form-control', rows: 10 %></div></div>"
    #Datetime
formDateTemplate = "<div class='form-group'><div class='control-label col-sm-2'><%= form.label #{columnNameCode} %></div><div class='col-sm-8'><%= form.text_area #{columnNameCode}, id: #{columnNameCode}, class: 'form-control', rows: 10 %></div></div>"
#Template da Tela de Detalhe:
    #String, integral e float
showGeneralTemplate = "<div class='well'><h4>#{modelName}:</h4><p><%= @#{modelName}.#{columnName}  %></p></div>"
    #Text
showTextTemplate = "<div class='well'><h4>#{modelName}:</h4><p><%= @#{modelName}.#{columnName}  %></p></div>"
    #Boolean
showBoolTemplate = "<div class='well'><h4>#{modelName}:</h4><p><%= @#{modelName}.#{columnName}  %></p></div>"
    #Datetime
showDateTemplate = "<div class='well'><h4>#{modelName}:</h4><p><%= @#{modelName}.#{columnName}  %></p></div>"

pastel = Pastel.new
table = TTY::Table.new(header: [ pastel.on_bright_cyan("PARAMETRO"), pastel.on_bright_cyan("VALOR")]) do |t|
  t << [ "Model:",  "#{modelNameMigration}"]
  t << [ "Campo:", "#{columnNameCode}"]
  t << [ "Tipo:", "#{columnType}"]
  t << [ "Path do Controller:", "#{controllerFileName}"]
  t << [ "Path do Template Form:", "#{viewFormPath}"]
  t << [ "Path do Template Show:", "#{viewShowPath}"]
  t << [ "Commando da Migração:", "#{migrationCommand}"]
end

puts table.render(:ascii, padding: [1, 1, 1, 1])

prompt.yes?("Tudo certo? Deseja Continuar?") do |q|
  q.suffix 'Sim/Nao'
end

#rails generate migration migrationCommand
#rake db:migrate

TTY::File.inject_into_file '../server-conheca/app/controllers/filename.rb', "\n #{modelName} \n", after: "#test"
print "\n" * 2
puts pastel.white.on_blue.bold('Controller Gerado!')
print "\n" * 2

box_2 = TTY::Box.frame(
  #top: 2,
  #left: 10,
  width: 100,
  height: 20,
  border: :thick,
  align: :center,
  padding: 3,
  title: {
    top_left: ' MANACA DIGITAL - PROJETO TARDIS | AUTOMATION 2019 '
  },
  style: {
    fg: :bright_yellow,
    bg: :blue,
    border: {
      fg: :bright_yellow,
      bg: :blue
    }
  }
) do
  "TEMPLATES GERADOS COM SUCESSO!          \n
  ######################################## \n
  Os seguintes arquivos foram gerados:     \n
  ######################################## \n
  "
end

case columnTypeCode
    when ":string"
        print "\n" * 2
        TTY::File.inject_into_file '../server-conheca/app/controllers/filename.rb', "\n #{formGeneralTemplate} \n", after: "#test"
        print "\n" * 2
        puts pastel.white.on_blue.bold("Formulário tipo #{columnType} Gerado!")
        print "\n" * 2
        TTY::File.inject_into_file '../server-conheca/app/controllers/filename.rb', "\n #{showGeneralTemplate} \n", after: "#test"
        print "\n" * 2
        puts pastel.white.on_blue.bold("Template Detalhe tipo #{columnType} Gerado!")
        print "\n" * 2
        puts box_2
        print "\n" * 5
        puts "Formulário: #{formGeneralTemplate}"
        puts "Detalhe: #{showGeneralTemplate}"
    when ":boolean"
        print "\n" * 2
        TTY::File.inject_into_file '../server-conheca/app/controllers/filename.rb', "\n #{formBoolTemplate} \n", after: "#test"
        print "\n" * 2
        puts pastel.white.on_blue.bold("Formulário tipo #{columnType} Gerado!")
        print "\n" * 2
        TTY::File.inject_into_file '../server-conheca/app/controllers/filename.rb', "\n #{showBoolTemplate} \n", after: "#test"
        print "\n" * 2
        puts pastel.white.on_blue.bold("Template Detalhe tipo #{columnType} Gerado!")
        print "\n" * 2
        puts box_2
        print "\n" * 5
        puts "Formulário: #{formBoolTemplate}"
        puts "Detalhe: #{showBoolTemplate}"
    when ":integer"
        print "\n" * 2
        TTY::File.inject_into_file '../server-conheca/app/controllers/filename.rb', "\n #{formBoolTemplate} \n", after: "#test"
        print "\n" * 2
        puts pastel.white.on_blue.bold("Formulário tipo #{columnType} Gerado!")
        print "\n" * 2
        TTY::File.inject_into_file '../server-conheca/app/controllers/filename.rb', "\n #{showBoolTemplate} \n", after: "#test"
        print "\n" * 2
        puts pastel.white.on_blue.bold("Template Detalhe tipo #{columnType} Gerado!")
        print "\n" * 2
        puts box_2
        print "\n" * 5
        puts "Formulário: #{formBoolTemplate}"
        puts "Detalhe: #{showBoolTemplate}"
    when ":float"
        print "\n" * 2
        TTY::File.inject_into_file '../server-conheca/app/controllers/filename.rb', "\n #{formBoolTemplate} \n", after: "#test"
        print "\n" * 2
        puts pastel.white.on_blue.bold("Formulário tipo #{columnType} Gerado!")
        print "\n" * 2
        TTY::File.inject_into_file '../server-conheca/app/controllers/filename.rb', "\n #{showBoolTemplate} \n", after: "#test"
        print "\n" * 2
        puts pastel.white.on_blue.bold("Template Detalhe tipo #{columnType} Gerado!")
        print "\n" * 2
        puts box_2
        print "\n" * 5
        puts "Formulário: #{formBoolTemplate}"
        puts "Detalhe: #{showBoolTemplate}"

    when ":text"

    else
        print "\n" * 2
        puts pastel.white.on_red.bold('Template não Gerado!!!')
        print "\n" * 2
end





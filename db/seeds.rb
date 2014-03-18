# it creates a new user
puts 'creating one inital user'
User.find_or_create_by(name: 'John Doe', username: 'john', password: 'adg')

# it creates some test questions
puts 'creating some test questions'
Question.find_or_create_by(caption: 'Do you like cats?')
Question.find_or_create_by(caption: 'Do you like sports?')
Question.find_or_create_by(caption: 'Would you like be a developer?')
Question.find_or_create_by(caption: 'Do you like Rails?')


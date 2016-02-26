games = {
  1 => {
    name: "Battleship",
    path: "battleship"
  },
  2 => {
    name: "Chess",
    path: "chess"
  },
  3 => {
    name: "Ghost",
    path: "ghost"
  },
  4 => {
    name: "Hangman",
    path: "handman"
  },
  5 => {
    name: "Mastermind",
    path: "mastermind"
  },
  6 => {
    name: "Memory",
    path: "memory_puzzle"
  }
  # need to finish
}

puts "WELCOME TO RUBY ARCADE"
puts "SELECT A GAME:"
games.keys.each { |game| puts "#{game}. #{games[game][:name]}" }

selection = gets.chomp.to_i
selection = games[selection][:path]
p selection

require_relative "#{selection}/#{selection}.rb"


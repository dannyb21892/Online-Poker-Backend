# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
player1 = Player.create(username: "dannyb", money: 100)
player2 = Player.create(username: "mkhan", money: 100)

match1 = Match.create

ps1m1 = PlayerSlot.create(player_id: player1.id, match_id: match1.id)
ps2m1 = PlayerSlot.create(player_id: player2.id, match_id: match1.id)

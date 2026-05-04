puts "Cleaning DB..."
Value.delete_all
Image.delete_all
Theme.delete_all
User.delete_all

puts "Creating themes..."
lager = Theme.create!(name: "Лагеры")
stout = Theme.create!(name: "Стауты")
wheat = Theme.create!(name: "Пшеничное")

puts "Creating beers..."
beers = [
  { name: "Heineken",                 file: "heineken.avif",                 theme: lager },
  { name: "Peroni Nastro Azzurro",    file: "peroni_nastro_azzurro.avif",    theme: lager },
  { name: "Жигулёвское",              file: "zhigulevskoe.avif",             theme: lager },

  { name: "Guinness Draught",         file: "guinness_draught.avif",         theme: stout },
  { name: "Лидское Портер",           file: "lidskoe_porter.avif",           theme: stout },
  { name: "Leffe Brune",              file: "leffe_brune.avif",              theme: stout },

  { name: "Schöfferhofer Hefeweizen", file: "schofferhofer_hefeweizen.avif", theme: wheat },
  { name: "Blanche Bière",            file: "blanche_biere.avif",            theme: wheat },
  { name: "Weiss Berg",               file: "weiss_berg.avif",               theme: wheat }
]
beers.each { |b| Image.create!(b.merge(ave_value: 0.0)) }

lager.update!(qty_items: lager.images.count)
stout.update!(qty_items: stout.images.count)
wheat.update!(qty_items: wheat.images.count)

puts "Creating demo user..."
User.create!(
  name: "Demo",
  email: "demo@example.com",
  password: "password",
  password_confirmation: "password"
)

puts "Done. Themes: #{Theme.count}, Images: #{Image.count}, Users: #{User.count}"
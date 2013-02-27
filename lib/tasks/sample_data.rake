namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Matt",
                 email: "goggin13@gmail.com",
                 password: "password")

    70.times do |n|
      user = User.create!(name: Faker::Name.name,
                                email: Faker::Internet.email,
                                password: "password")
      puts "Created new user, #{user.name}, #{n+1} / 70"
      25.times do |i|
        user.micro_posts.create! content: "hello, world - #{i}"
      end
    end
  end
end
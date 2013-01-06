namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_user
  end
end

def make_user
  user = User.create!(name:     "Harish Porwal",
                       email:    "harish.porwal@gmail.com",
                       password: "password",
                       password_confirmation: "password")
end


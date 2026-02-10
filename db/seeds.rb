# Seed fake user and requests for development/testing

# Create or find user
user = User.find_or_create_by!(email: 'demo@example.com') do |u|
  u.password = 'password123'
  u.password_confirmation = 'password123'
end

# Create fake requests if they don't exist
Request.find_or_create_by!(id: 1) do |r|
  r.user = user
  r.title = 'Fix login page'
  r.description = 'The login button is not responsive on mobile devices. Need to update CSS media queries.'
  r.status = :pending
end

Request.find_or_create_by!(id: 2) do |r|
  r.user = user
  r.title = 'Add user profile page'
  r.description = 'Create a user profile page where users can view and edit their information.'
  r.status = :pending
end

Request.find_or_create_by!(id: 3) do |r|
  r.user = user
  r.title = 'Database optimization'
  r.description = 'Optimize slow queries in the requests listing endpoint.'
  r.status = :approved
end

Request.find_or_create_by!(id: 4) do |r|
  r.user = user
  r.title = 'Update documentation'
  r.description = 'Update API documentation with new endpoints.'
  r.status = :rejected
end

puts "✓ Seeded 1 user and 4 requests"


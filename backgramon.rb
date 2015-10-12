require 'instagram'  

id = "a8b24fe4d820402aad4407141f4785be"
secret = "b7ed381ce12b4da5a21193a0ab58ac0b"
temp_post_text = []
temp_standard_image = []
temp_comments_poster = []
temp_comments_made = []
results = []
media = []
comments = []

# Run the configure method to communicate your credentials  - from http://hereisahand.com/using-the-instagram-api/
Instagram.configure do |config|  
  config.client_id = id
  config.client_secret = secret
end

user_name = [ARGV[0]] # User ID
user_data = Instagram.user_search(user_name[0]) #Grabs their user info.
user_id = user_data[0]["id"] #Seperates out their userID for polling.

recent_media = Instagram.user_recent_media(user_id)

# Print out the result
puts user_data.length
puts user_data.inspect  

temp_post_text = recent_media.each.map {|x| x['caption']['text']}

temp_standard_image = recent_media.each.map {|x| x['images']['standard_resolution']['url']}

temp_comments_poster = recent_media.each.map{|x| x['comments']['data'].each.map{|y| y['from']['username']}}



temp_comments_made = recent_media.each.map{|x| x['comments']['data'].each.map {|y| y['text']}}

puts "#{ARGV[0]}'s Instagram Feed Test"
puts temp_post_text[0]
puts temp_comments_made[0]
puts temp_comments_poster[0]

comments = temp_comments_poster.each.zip(temp_comments_made.each)
puts comments
# When dealing with all of this, you have to define the hash as you would an array point. aka [0]['caption']

# a =  user_comments[0].caption.text


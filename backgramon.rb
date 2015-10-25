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

user_name = ["davisherbfarms"]#[ARGV[0]] # User ID
user_data = Instagram.user_search(user_name[0]) #Grabs their user info.
user_id = user_data[0]["id"] #Seperates out their userID for polling.
recent_media = Instagram.user_recent_media(user_id)

# Print out the result
#puts user_data.length
#puts user_data.inspect  

temp_post_text = recent_media.each.map {|x| x['caption']['text']}

temp_standard_image = recent_media.each.map {|x| x['images']['standard_resolution']['url']}

temp_comments_poster = recent_media.each.map{|x| x['comments']['data'].each.map{|y| y['from']['username']}}

temp_comments_made = recent_media.each.map{|x| x['comments']['data'].each.map {|y| y['text']}}

puts "\n\n#{ARGV[0].capitalize}'s Instagram Feed Backup\n\n"

@nothing = ""
@total = ""
for i in 0..(recent_media.length - 1) do
	puts "TITLE:\t #{temp_post_text[i]} \n ------------------- \nIMAGE URL:\t #{temp_standard_image[i]} \n\n"
	comment = temp_comments_poster[i].flatten.zip(temp_comments_made[i].flatten)
	for k in 0..(comment.length - 1) do
	puts comment[k].join("\t")
end
	puts "\n\n"	
end

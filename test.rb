require 'rubypress'
require 'instagram'  
require 'mime/types'
require "open-uri"

wp = Rubypress::Client.new(:host => "localhost",
                           :username => "backgramon",
                           :password => "Password1!")

id = "a8b24fe4d820402aad4407141f4785be"
secret = "b7ed381ce12b4da5a21193a0ab58ac0b"
temp_post_text = []
temp_standard_image = []
temp_comments_poster = []
temp_comments_made = []
results = []
media = []
comments = []
range = [*'0'..'9',*'A'..'Z',*'a'..'z']
output_name = Array.new(50){ range.sample }.join

# Run the configure method to communicate your credentials  - from http://hereisahand.com/using-the-instagram-api/
Instagram.configure do |config|  
  config.client_id = id
  config.client_secret = secret
end

user_name = ["rivercityhh"]#[ARGV[0]] # User ID
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

puts "\n\n#{user_name[0].capitalize}'s Instagram Feed Backup\n\n"

check = wp.getPosts(:fields => {:number => '17', :name => 'rivercityhh'})
posts = check.each.map {|x| x['post_id']}
content = posts.each.map {|x| wp.getPost(:post_id => "#{x}")}
text = content.each.map {|x| x['post_content']}
#a[0]['post_content'].include?(temp_post_text[0])

for i in 0..(text.length-1) do
temp_post_text.reject! {|x| text[i].include? x}
end

@nothing = ""
@total = ""
for i in 0..(temp_post_text.length - 1) do
	puts "TITLE:\t #{temp_post_text[i]} \n ------------------- \nIMAGE URL:\t #{temp_standard_image[i]} \n\n"
	comment = temp_comments_poster[i].flatten.zip(temp_comments_made[i].flatten)
	for k in 0..(comment.length - 1) do
	puts comment[k].join("\t")
end
	puts "\n\n"	
	
	range = [*'0'..'9',*'A'..'Z',*'a'..'z']
	output_name = Array.new(50){ range.sample }.join
	
	open("#{temp_standard_image[i]}") {|f|
	File.open("/home/benzene/insta/#{output_name}.jpg","wb") do |file|
	     file.puts f.read
   	   end
	}
	filename = "/home/benzene/insta/#{output_name}.jpg"
	embed_url = wp.uploadFile(:data => {
	    :name => filename,
	    :type => MIME::Types.type_for(filename).first.to_s,
	    :bits => XMLRPC::Base64.new(IO.read(filename))
	    })
	real_name = user_name[0].to_s
	wp.newPost( :blog_id => "your_blog_id", # 0 unless using WP Multi-Site, then use the blog id
            :content => {
                         :post_status  => "publish",
                         :post_date    => Time.now,
                         :post_content => "<" + "img src=\"#{embed_url['url']}\" alt=\"ewww\" /" + ">" + "\n #{temp_post_text[i]}",
                         :post_title   => "#{real_name}",
                         :post_name    => "/#{real_name}",
                         :post_author  => 1, # 1 if there is only the admin user, otherwise the user's id
                         :terms_names  => {
                            :category   => [real_name ,'Category Two','Category Three'],
                            :post_tag => ["#{real_name}",'Tag Two', 'Tag Three']
                                          }
                         }
            )  
end


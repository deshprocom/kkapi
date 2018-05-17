json.id            topic.id
json.title         topic.title.to_s
json.cover_link    topic.cover_link.to_s
json.body          topic.body
json.body_type     topic.body_type
json.stickied      topic.stickied
json.excellent     topic.excellent
json.location do
  json.lat topic.lat
  json.lng topic.lng
  json.address_title topic.address_title.to_s
  json.address topic.address.to_s
end
json.images do
  json.array! topic.images do |image|
    json.url image.to_s
  end
end
json.total_views    topic.total_views
json.total_comments topic.total_comments
json.total_likes    topic.likes_count
json.created_at     topic.created_at.to_i

if source.class.name == 'Info'
  json.info do
    json.id            source.id
    json.title         source.title
    json.date          source.date
    json.image         source.preview_image

    json.type do
      json.slug  source.info_type.slug
      json.name  source.info_type.name
    end
    json.comments_count source.comments_count
    json.likes_count source.likes_count
    json.total_views source.total_views
  end
else
  json.hotel do
    json.id        source.id
    json.title     source.title
    json.location  source.location
    json.logo      source.preview_logo
  end
end
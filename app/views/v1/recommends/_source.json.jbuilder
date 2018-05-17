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
  end
else
  json.hotel do
    json.id        source.id
    json.title     source.title
    json.location  source.location
    json.logo      source.preview_logo
  end
end
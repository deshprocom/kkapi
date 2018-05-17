case model_type
when 'user'
  json.target_user do
    json.user_id       target.user_uuid
    json.nick_name     target.nick_name
    json.gender        target.gender
    json.avatar        target.avatar_path.to_s
    json.signature     target.signature.to_s
    json.created_at    target.created_at.to_i
  end
when 'info'
  json.info do
    json.id            target.id
    json.title         target.title
    json.date          target.date
    json.preview_image target.preview_image
  end
when 'hotel'
  json.hotel do
    json.id            target.id
    json.title         target.title
    json.location      target.location
    json.preview_logo  target.preview_logo
  end
when 'topic'
  json.topic do
    json.id            target.id
    json.title         target.title.to_s
    json.cover_link    target.cover_link.to_s
    json.body          target.body
    json.body_type     target.body_type
  end
when 'comment'
  json.comment do
    json.id            target.id
    json.body          target.body
    model_name = target.target.class.to_s.tableize.singularize
    json.partial! 'v1/briefs/base', model_type: model_name, target: target.target
  end
when 'reply'
  json.reply do
    json.id            target.id
    json.body          target.body
    model_name = target.target.class.to_s.tableize.singularize
    json.partial! 'v1/briefs/base', model_type: model_name, target: target.target
  end
end
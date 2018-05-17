json.reply_id    reply.id
json.reply_body  reply.body
json.reply_user do
  json.partial! 'v1/users/user_brief', user: reply.user
end
json.created_at reply.created_at.to_i

# 该回复的上级 可能是评论 也可能是回复 但都有一个comment主体
comment = reply.comment
json.parent_comment do
  json.comment_id   comment.id
  json.comment_body comment.body
  json.comment_user do
    json.partial! 'v1/users/user_brief', user: comment.user
  end
end

# 如果是回复下回复的，那么就要把上级回复也渲染出来
target_reply = reply.reply
if target_reply.present?
  json.parent_reply do
    json.reply_id    target_reply.id
    json.reply_body  target_reply.body
    json.reply_user do
      json.partial! 'v1/users/user_brief', user: target_reply.user
    end
  end
end

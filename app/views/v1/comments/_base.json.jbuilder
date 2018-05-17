json.id               comment.id
json.target_type      comment.target_type.tableize.singularize
json.target_id        comment.target_id
json.body             comment.body.to_s
json.created_at       comment.created_at.to_i
json.total_replies    comment.replies_count
json.user do
  json.partial! 'v1/users/user_brief', user: comment.user
end
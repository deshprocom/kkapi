json.partial! 'v1/topics/base', topic: topic
json.user do
  json.partial! 'v1/users/user_brief', user: topic.user
end

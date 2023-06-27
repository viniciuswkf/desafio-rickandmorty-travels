require "kemal"

# Este arquivo aqui faz com que seja mais fácil
# . tratar erros em outras rotas usando env.response.status_code(...)

error 400 do |env|
  env.response.content_type = "application/json"
  {"status": "error", "message": "bad_request"}.to_json
end

error 401 do |env|
  env.response.content_type = "application/json"
  {"status": "error", "message": "not_authorized"}.to_json
end

error 404 do |env|
  env.response.content_type = "application/json"
  {"status": "error", "message": "not_found"}.to_json
end

error 500 do |env|
  env.response.content_type = "application/json"
  {"status": "error", "message": "internal_server_error"}.to_json
end

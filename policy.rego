package envoy.authz

default allow = false

role_inherits[child] = parents {
  entry := data.roles[_]
  child := entry.role
  parents := entry.inherits
}

get_all_roles(base_role) = result {
  result := graph.reachable(role_inherits, {base_role})
}

allow {
  path := input.request.http.path
  method := input.request.http.method
  token := io.jwt.decode(input.request.http.headers.authorization)
  roles := token.payload.roles
  resource := data.resources[_]
  re_match(resource.pattern, path)
  method == resource.methods[_]
  some required_role
  required_role == resource.roles[_]
  some user_role
  user_role == roles[_]
  inherited := get_all_roles(user_role)
  required_role == user_role or required_role == inherited[_]
}
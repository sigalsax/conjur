# The phrasing of this definition is a little awkward. What I really
# wanted was "the JSON should include", but json_spec already defines
# that. Weirdly, that defintion only looks at the values in the
# JSON. I want to make sure the keys match, too.
Then /^a subset of the JSON should include:$/ do |json|
  last_json.should include_json_subset(JsonSpec.remember(json))
end

  
     

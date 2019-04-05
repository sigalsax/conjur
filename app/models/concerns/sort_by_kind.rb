module SortByKind
  SORT_SCORE = {
    "policy" => 0,
    "user" => 10,
    "group" => 20,
    "host" => 30,
    "layer" => 40,
    "variable" => 50,
    "webservice" => 60
  }

  def self.sort_score kind
    SORT_SCORE[kind] || 1000
  end
end

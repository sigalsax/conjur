# frozen_string_literal: true

module RoleGraph
  def v5_graph
    edges = conjur_role.graph
    nodes = edges.map { |edge| [edge["parent"], edge["child"]] }
                 .reduce(Set.new, :merge)
                 .map(&method(:create_node))

    {
      nodes: nodes,
      edges: edges
    }
  end

  def v4_graph
    nodeSet = Set.new

    edges = conjur_api
            .role_graph(roleid)
            .as_json["graph"]
            .select do |edge|
              !edge["child"].include?("@") && !edge["parent"].include?("@")
            end
            .each do |edge|
      nodeSet.merge [edge["child"], edge["parent"]]
    end

    nodes = nodeSet.map do |node|
      vertex = node.split(":", 3)
      _, kind, id = vertex
      {
        id: id,
        vertex: node,
        current: id == id && kind == kind,
        kind: kind,
        url: resource_id_path(node)
      }
    end

    {
      nodes: nodes,
      edges: edges
    }
  end

  protected

  def create_node(node)
    _, kind, id = node.split(":", 3)
    {
      id: id,
      vertex: node,
      kind: kind,
      url: resource_id_path(node),
      current: conjur_role.id.to_s == node
    }
  end

  def ancestor_edge(role)
    {
      parent: role.id.to_s,
      child: conjur_role.id.to_s
    }
  end

  def descendent_edge(grant)
    role = grant.member
    {
      parent: conjur_role.id.to_s,
      child: role.id.to_s
    }
  end
end

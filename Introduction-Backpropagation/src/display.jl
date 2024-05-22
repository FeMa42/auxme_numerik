module DisplayGraph

using GraphViz

export display_graph

function generate_dot(nodes::Vector)
    dot_str = "digraph computation_graph {\n"
    prev_string = ""
    node_id = 1

    function add_node(node)
        label = string(round(node.data, digits=3))
        grad = string(round(node.grad, digits=3))
        dot_str *= "node$(node_id) [label=\"v:$label \n g:$grad\", shape=box];\n"
        node_id += 1

        valua_node_id = node_id - 1

        if length(node.op) > 0
            op_label = node.op
            dot_str *= "node$(node_id) [label=\"$op_label\"];\n"
            prev_node_id = node_id - 1
            prev_string *= "node$(node_id) -> node$(prev_node_id);\n"
            node_id += 1
        end

        current_node_id = node_id - 1

        # Recursively add previous nodes
        for prev_node in node.prev
            returned_node_id = add_node(prev_node)
            prev_string *= "node$(returned_node_id) -> node$(current_node_id);\n"
        end
        return valua_node_id
    end

    for node in nodes
        add_node(node)
    end

    dot_str *= prev_string
    dot_str *= "}"
    return dot_str
end

function display_graph(last_value)
    nodes = [last_value]
    dot_output = generate_dot(nodes)
    graph_code = "dot\"\"\"$dot_output\"\"\""
    eval(Meta.parse(graph_code))
end

end # module DisplayGraph
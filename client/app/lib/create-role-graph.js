import d3 from 'd3';
import dagreD3 from 'dagre-d3';
import cx from 'classnames';
import escape from 'lodash.escape';

const labelFromNode = node => (`
    <span class="b-link-to icon-${node.kind}">${escape(node.id)}<span>
`);

export default function createRoleGraph(graph = {nodes: [], edges: []}, svgSelector = "#role-graph") {
    // Create the input graph
    var g = new dagreD3.graphlib.Graph()
        .setGraph({})
        .setDefaultEdgeLabel(function() { return {}; });

    // Create some nodes
    graph.nodes.forEach(node => {
        var label = labelFromNode(node);
        g.setNode(node.vertex,  {
            label,
            labelType: 'html',
            class: cx({
                "current-role": node.current,
            })
        });
    });

    // Create some edges
    graph.edges.forEach(edge => {
        g.setEdge(edge.parent, edge.child);
    });

    // Create the renderer
    var render = new dagreD3.render();

    // Set up an SVG group so that we can translate the final graph.
    var svg = d3.select(svgSelector)
        .classed('role-graph-svg', true);

    svg.selectAll("*")
        .remove();
    var svgGroup = svg.append("g");

    // Run the renderer. This is what draws the final graph.
    render(svgGroup, g);

    // Set up zoom support

    var width = g.graph().width,
        height = g.graph().height,
        affordance = 0.8;

    let interactive = false;
    g.getInteractive = () => interactive;
    
    const onZoom = function() {
        let translate = zoom.translate();
        let tx = translate[0], ty = translate[1];
        let scale = d3.event.scale;
        zoom.translate([tx, ty]);
        svgGroup.attr("transform", "translate(" + [tx, ty] + ")" +
            "scale(" + scale + ")");
    };

    var zoom = d3.behavior.zoom()
        .on('zoom', onZoom);

    svg.attr("preserveAspectRatio", "xMidYMid meet")
        .attr("viewBox", `0 0 ${width} ${height}`)
        .on('mousedown', function() {
            if (!interactive) {
                interactive = true;
                svg.call(zoom);
            }
        })
        .on('mouseleave', function() {
            interactive = false;
            svg.on('.zoom', null);
        });

    zoom
        .scaleExtent([0.5, Infinity])
        .translate([
            width*(1-affordance) / 2,
            height*(1-affordance) / 2
        ])
        .scale(affordance)
        .event(svg);

    return g;
}

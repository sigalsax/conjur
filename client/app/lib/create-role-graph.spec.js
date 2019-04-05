import { use, expect} from 'chai';
import $ from 'jquery';
import chai_dom from 'chai-dom';
import createRoleGraph from 'lib/create-role-graph';

use(chai_dom);

describe('RoleGraph', () => { 
  const createElement = (id = 'role-graph-canvas') => {
    document.body.innerHTML = `
    <svg id="${id}" height="500" width="500"></svg>
    `;
  };

  const graphData = {
    nodes: [
      {
        id: 'user',
        vertex: 'cucumber:user:user',
        kind: 'user',
        current: true
      },
      {
        id: 'group',
        vertex: 'cucumber:group:group',
        kind: 'group',
        current: true
      },
    ],
    edges: [
      {
        parent: 'cucumber:group:group',
        child: 'cucumber:user:user'
      }
    ]
  };

  const renderGraph = () => {
    return createRoleGraph(graphData, '#role-graph-canvas');
  }

  it('renders an empty graph by default', () => {
    createElement('role-graph');
    createRoleGraph();

    let graph = document.querySelector('svg#role-graph');
    expect(graph).to.have.class('role-graph-svg');
  });

  it('renders a graph to the default target', () => {
    createElement('role-graph');
    createRoleGraph(graphData);

    let graph = document.querySelector('svg#role-graph');
    expect(graph).to.have.class('role-graph-svg');
  });

  it('renders a provided graph', () => {
    createElement();    
    renderGraph();

    let graph = document.querySelector('svg#role-graph-canvas');
    expect(graph).to.have.class('role-graph-svg');
    expect(graph.querySelector('span.b-link-to.icon-user')).to.contain.text('user')
    expect(graph.querySelector('span.b-link-to.icon-group')).to.contain.text('group')
  });

  it('responds to mouse events', () => {
    createElement();    
    let g = renderGraph();
    let graph = document.querySelector('svg#role-graph-canvas');
    
    graph.dispatchEvent(new Event('mousedown'));
    expect(g.getInteractive()).to.eq(true);

    graph.dispatchEvent(new Event('mousedown'));
    expect(g.getInteractive()).to.eq(true);

    graph.dispatchEvent(new Event('mouseleave'));
    expect(g.getInteractive()).to.eq(false);
  });

  it('properly escapes special characters in display name', () => {
    let data = {
      nodes: [
        {
          id: 'Sam<a onmouseover=\'alert(document.title)\'> Brown</a>',
          vertex: 'cucumber:user:Sam<a onmouseover=\'alert(document.title)\'> Brown</a>',
          kind: 'user',
          current: true
        }
      ],
      edges: []
    };

    createElement();
    createRoleGraph(data, '#role-graph-canvas');

    let graph = document.querySelector('svg#role-graph-canvas');
    expect(graph.querySelector('span.b-link-to.icon-user')).to.contain.text('Sam<a onmouseover=\'alert(document.title)\'> Brown</a>')
  })
});

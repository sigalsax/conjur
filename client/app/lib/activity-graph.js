import d3 from 'd3';
import _, {merge} from 'lodash';

var bisector = d3.bisector((d) => {
  return d.date;
}).left;

var oneDay = 24*60*60*1000;

function _translate(x, y) {
  return `translate(${x},${y})`;
}

export default class ActivityGraph {

  _getHeight(top, bottom) {
    return window.parseFloat(400) - top - bottom;
  }

  _getWidth(left, right) {
    return window.parseFloat(700) - left - right;
  }

  constructor(id,
              legend={},
              data=[]) {
    this.state = {};
    this.props = {
      data: data.map(d => {
        d.date = new Date(d.date);
        return d;
      }),
      defaultOptions: {
        legend: {},
        axis: {
          x: {
            label: 'X axis'
          },
          y: {
            label: 'Y axis'
          }
        },
        margin: {
          top: 20,
          right: 145,
          bottom: 30,
          left: 50
        }
      },
      options: {
        legend
        ,
        axis: {
          y: {
            label: 'Value'
          }
        }
      },
      xAxis: (axis) => axis
    }

    this.svg = {};


    var chart = d3.select(id);
    this.svg.chart = chart[0][0];


    this.state = this._calculateInitialState(this.props);

    chart.select('svg').remove();
    var svg = chart
      .classed("svg-container", true) //container class to make it responsive
      .append("svg")
      //responsive SVG needs these 2 attributes and no width and height attr
      .attr("preserveAspectRatio", "xMinYMin meet")
      .attr("viewBox", "0 0 700 400")
      //class to make it responsive
      .classed("svg-content-responsive", true)
      .attr('class', 'd3-line-chart')
      .append('g')
      .attr('class', 'd3-line-chart__inner')
      .attr('transform', _translate(this.state.margin.left, this.state.margin.top));

    this.svg.svg = svg;

    this.svg.axis = svg.append('g')
      .attr('class', 'd3-axis');

    this.svg.axis.append('g')
      .attr('class', 'd3-axis__x');

    this.svg.axis.append('g')
      .attr('class', 'd3-axis__y');

    this.svg.legend = svg.append('g')
      .attr('class', 'd3-legend');

    this.svg.graph = svg.append('g')
      .attr('class', 'd3-graph');

    this.svg.focus = this.svg.graph.append('g')
      .attr('class', 'd3-graph__focus');

    this._update();
  }

  _update() {
    this._drawAxisX();
    this._drawAxisY();
    this._drawLegend();
    this._drawLine();
    this._drawFocus();
  }

  _calculateDims(options) {
    var width = this._getWidth(options.margin.left,
      options.margin.right),
      height = this._getHeight(options.margin.top,
        options.margin.bottom),
      fullWidth = (
        width +
        options.margin.left +
        options.margin.right
      ),
      fullHeight = (
        height +
        options.margin.top +
        options.margin.bottom
      );
    return {width, height};
  }

  _calculateInitialState(props) {
    var options = merge({}, props.options,
      props.defaultOptions);


    const {width, height} = this._calculateDims(options);

    var color = d3.scale.category10();

    color.domain(d3.keys(options.legend)
      .filter(function(key) {
        return key !== 'date';
      }));

    var data = color.domain().map(function(name) {
      return {
        name,
        values: props.data.map(function(d) {
          return {
            date: d.date,
            value: Number(d[name])
          };
        })
      };
    });

    var xExtent = d3.extent(props.data, function(d) {
      return d.date;
    });

    var currentDate = (new Date()).getTime();

    var xMin = xExtent[0] || new Date(currentDate - oneDay),
      xMax = xExtent[1] || new Date(currentDate);

    var yMin = d3.min(data, function(c) {
        return d3.min(c.values, function(v) {
          return v.value;
        });
      }) || 0;

    if (yMin < 1) {
      yMin = 0;
    }

    var yMax = d3.max(data, function(c) {
        return d3.max(c.values, function(v) {
          return v.value;
        });
      }) || 4;

    yMax += 1;

    if (yMax < 5) {
      yMax = 5;
    }

    var x = this._getScaleX('time')
        .range([0, width])
        .domain([xMin, xMax]),

      y = this._getScaleX('linear')
        .range([height, 0])
        .domain([yMin, yMax]),

      legendScale = d3.scale.ordinal()
        .domain([])
        .range([0, 20, 40, 60, 80, 100, 120, 140]),

      scales = {
        x,
        y,
        yMax,
        legend: legendScale
      };

    var line = this._getLine(scales);

    const lineDraw = _.mapValues(options.legend, () => true);

    return {
      ready: true,
      legend: options.legend,
      lineDraw: _.assign(lineDraw, this.state.lineDraw || {}),
      axis: options.axis,
      margin: options.margin,
      width,
      height,
      color,
      scales,
      lineStencil: line,
      data
    };
  }

  _getScaleX(type) {
    if (type === 'linear') {
      return d3.scale.linear();
    }
    else if (type === 'time') {
      return d3.time.scale();
    }

    return null;
  }

  _getLine(scales) {
    return d3.svg.line()
      .x(function(d) {
        return scales.x(d.date);
      })
      .y(function(d) {
        return scales.y(d.value);
      });
  }

  _drawAxisX() {
    var xAxis = d3.svg.axis()
      .scale(this.state.scales.x)
      .orient('bottom');

    this.svg.axis.select('.d3-axis__x')
      .attr('transform', _translate(0, this.state.height))
      .call(this.props.xAxis(xAxis))
      .append("text")
        .attr("transform", "translate(240, 30)")
        .text("TIME");
  }

  _drawAxisY() {
    var yAxis = d3.svg.axis()
      .scale(this.state.scales.y)
      .orient('left')
      .ticks(this.state.scales.yMax > 10 ? 10 : this.state.scales.yMax)
      .tickFormat(d3.format('d'))
      .tickSubdivide(0);

    var axis = this.svg.axis.select('.d3-axis__y')
      .call(yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", "-2em")
        .attr("x", "-20em")
        .text("ACTIONS");

    if (typeof this.state.yAxisLabel === 'string') {
      this._drawAxisLabel(axis, this.state.yAxisLabel, true);
    }
  }

  _drawAxisLabel(axis, text, rotate) {
    var label = axis.append('text');

    if (typeof rotate === 'boolean' && rotate === true) {
      label.attr('transform', 'rotate(-90)')
        .attr('y', 0 - this.state.margin.left)
        .attr('x', 0 - (this.state.height / 2))
        .attr('dy', '1em')
        .style('text-anchor', 'middle')
        .text(text);
    }
    else {
      label.attr('transform',
        _translate(this.state.width / 2,
          this.state.height + this.state.margin.bottom))
        .style('text-anchor', 'middle')
        .text(text);
    }
  }

  _drawLegend() {
    var self = this,
      legend,
      enter;

    this.svg.legend
      .selectAll('.d3-legend__item')
      .remove();

    legend = this.svg.legend
      .selectAll('.d3-legend__item')
      .data(d3.keys(this.state.legend));

    /* eslint-disable no-invalid-this */
    enter = legend
      .enter()
      .append('g')
      .attr('class', 'd3-legend__item')
      .attr('data-graph-line-i', function(d) {
        return `${d}`;
      })
      .on('mouseover', function(d) {
        self._handleLegendMouseover(this, d);
      })
      .on('mouseout', function(d) {
        self._handleLegendMouseout(this, d);
      })
      .on('click', function(d) {
        self._handleLegendClick(this, d);
      });

    legend.style('opacity', function(d) {
      return self.state.lineDraw[d] ? 0.9 : 0.2;
    });

    /* eslint-enable no-invalid-this */
    enter.append('circle')
      .attr('cx', this.state.width + 30)
      .attr('cy', function(d, i) {
        return self.state.scales.legend(i) - 3.1;
      })
      .attr('r', 5.5)
      .style('fill', function(d) {
        return self.state.color(d);
      });

    enter.append('text')
      .attr('x', this.state.width + 40)
      .attr('y', function(d, i) {
        return self.state.scales.legend(i);
      })
      .text(function(d) {
        return self.state.legend[d];
      });
  }

  _handleLegendMouseover(that) {
    var opacity = parseFloat(that.style.opacity);

    if (opacity >= 0.9) {
      d3.select(that)
        .style('opacity', 1);
    }
    else {
      d3.select(that)
        .style('opacity', 0.5);
    }
  }

  _handleLegendMouseout(that) {
    var opacity = parseFloat(that.style.opacity);

    if (opacity >= 0.9) {
      d3.select(that)
        .style('opacity', 0.9);
    }
    else {
      d3.select(that)
        .style('opacity', 0.2);
    }
  }

  _handleLegendClick(that) {
    const up = {},
      id = that.getAttribute('data-graph-line-i');


    _.set(this.state.lineDraw, id, !this.state.lineDraw[id]);
    const lineDraw = this.state.lineDraw;

    var yMin = d3.min(this.state.data, function(c) {
        if (lineDraw[c.name]) {
          return d3.min(c.values, function(v) {
            return v.value;
          });
        }
        else {
          return null;
        }
      }) || 0;

    if (yMin < 1) {
      yMin = 0;
    }

    var yMax = d3.max(this.state.data, function(c) {
        if (lineDraw[c.name]) {
          return d3.max(c.values, function(v) {
            return v.value;
          });
        }
        else {
          return null;
        }
      }) || 4;

    yMax += 1;

    if (yMax < 5) {
      yMax = 5;
    }

    const y = this._getScaleX('linear')
      .range([this.state.height, 0])
      .domain([yMin, yMax]);

    _.set(this.state.scales, 'y', y);
    _.set(this.state.scales, 'yMax', yMax);
    const scales = this.state.scales;

    const line = this._getLine(scales);

    Object.assign(this.state, ...{
      lineDraw,
      scales,
      lineStencil: line
    });

    this._update();
  }

  _drawLine() {
    var self = this,
      line;

    var data = _.filter(this.state.data, function(e) {
      return self.state.lineDraw[e.name];
    });

    this.svg.graph.selectAll('.d3-graph__line')
      .remove();

    line = this.svg.graph.selectAll('.d3-graph__line')
      .data(data)
      .enter()
      .append('g')
      .attr('class', 'd3-graph__line')
      .attr('id', function(d) {
        return `d3-legend__item--${d.name}`;
      });

    line.append('path')
      .attr('class', 'line')
      .attr('d', function(d) {
        return self.state.lineStencil(d.values);
      })
      .style('stroke', function(d) {
        return self.state.color(d.name);
      });
  }

  _drawFocus() {
    var self = this;

    var circle = this.svg.focus.selectAll('.d3-graph__focus-circle')
      .data(this.state.data)
      .enter()
      .append('g')
      .attr('class', 'd3-graph__focus-circle')
      .attr('id', function(d) {
        return `d3-graph__focus-circle--${d.name}`;
      })
      .style('display', 'none');

    circle.append('circle')
      .attr('r', 4.5);

    circle.append('text')
      .attr('x', 9)
      .attr('dy', '.35em');

    this.svg.focus.selectAll('.d3-graph__focus-line')
      .data([1])
      .enter()
      .append('line')
      .attr('class', 'd3-graph__focus-line')
      .attr('x1', 0)
      .attr('y1', 0)
      .attr('x2', 0)
      .attr('y2', this.state.height)
      .style('display', 'none')
      .style('stroke', 'gray')
      .style('stroke-width', 0.5)
      .style('stroke-dasharray', '5,10');

    /* eslint-disable no-invalid-this */
    this.svg.graph.selectAll('.d3-graph__overlay')
      .remove();

    this.svg.graph.selectAll('.d3-graph__overlay')
      .data([1])
      .enter()
      .append('rect')
      .attr('class', 'd3-graph__overlay')
      .attr('width', this.state.width)
      .attr('height', this.state.height)
      .on('mouseover', function() {
        self.svg.focus.selectAll('.d3-graph__focus-line')
          .style('display', null);
      })
      .on('mouseout', function() {
        self.svg.focus.selectAll('.d3-graph__focus-line')
          .style('display', 'none');

        self.svg.focus.selectAll('.d3-graph__focus-circle')
          .style('display', 'none');
      })
      .on('mousemove', function() {
        self._handleFocusMousemove(this);
      });

  }

  _handleFocusMousemove(overlay) {
    var self = this,
      mouse = d3.mouse(overlay)[0],
      x0 = this.state.scales.x.invert(mouse);

    this.svg.focus.selectAll('.d3-graph__focus-line')
      .attr('transform', _translate(this.state.scales.x(x0), 0));

    this.state.data
      .filter((data) => {
        return this.state.lineDraw[data.name];
      })
      .map((data) => {
        var i = bisector(data.values, x0, 1),
          d0 = data.values[i - 1],
          d1 = data.values[i],
          ret = {
            name: data.name,
            data: {
              value: []
            }
          };

        if (typeof d0 === 'object' && typeof d1 === 'object') {
          var d = x0 - d0.date > d1.date - x0 ? d1 : d0;

          ret.data = d;
        }

        return ret;
      }).map(function(d) {
      var circle = document.getElementById(`d3-graph__focus-circle--${d.name}`),
        line = document.getElementById(`d3-legend__item--${d.name}`);

      if (d.data.value > 0 && line.style.opacity !== '0') {
        d3.select(circle)
          .style('display', null)
          .attr('transform',
            _translate(self.state.scales.x(d.data.date),
              self.state.scales.y(d.data.value)))

          .select('text').text(d3.format('d')(d.data.value));
      }
      else {
        d3.select(circle)
          .style('display', 'none');
      }
    });
  }
};

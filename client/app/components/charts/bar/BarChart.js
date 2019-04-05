import React from 'react';
import PropTypes from 'prop-types';

import d3 from 'd3';
import _ from 'lodash';

import Chart from '../Chart';
import DataSeries from './DataSeries';
import Axis from '../Axis';

function roundUp(x) {
  const y = Math.pow(10, x.toString().length - 1);

  return Math.ceil(x / y) * y;
}

class BarChart extends React.Component {

  static propTypes = {
    data: PropTypes.array.isRequired,
    height: PropTypes.number,
    orient: PropTypes.oneOf(['left', 'top', 'right', 'bottom']),
    margins: PropTypes.object,
    dataMargins: PropTypes.object,
    xValueAccessor: PropTypes.func,
    yValueAccessor: PropTypes.func,
    xAxis: PropTypes.bool,
    xAsixType: PropTypes.oneOfType([PropTypes.oneOf(['ordinal']), PropTypes.func]),
    xAxisOrient: PropTypes.oneOf(['bottom', 'top']),
    xAxisTicks: PropTypes.array,
    xAxisTicksValues: PropTypes.array,
    xAxisInnerTickSize: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    xAxisOuterTickSize: PropTypes.number,
    xAxisTickPadding: PropTypes.number,
    xAxisTickFormat: PropTypes.func,
    xAxisDrawLine: PropTypes.bool,
    xAxisDrawTicks: PropTypes.bool,
    xAxisDrawLabels: PropTypes.bool,
    yAxis: PropTypes.bool,
    yAsixType: PropTypes.oneOfType([PropTypes.oneOf(['log', 'linear']), PropTypes.func]),
    yAxisOrient: PropTypes.oneOf(['right', 'left']),
    yAxisTicks: PropTypes.array,
    yAxisTicksValues: PropTypes.array,
    yAxisInnerTickSize: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    yAxisOuterTickSize: PropTypes.number,
    yAxisTickPadding: PropTypes.number,
    yAxisTickFormat: PropTypes.func,
    yAxisDrawLine: PropTypes.bool,
    yAxisDrawTicks: PropTypes.bool,
    yAxisDrawLabels: PropTypes.bool,
    onMouseOver: PropTypes.func
  };

  static defaultProps = {
    data: [],
    margins: {top: 10, right: 15, bottom: 10, left: 60},
    dataMargins: {top: 5, right: 5, bottom: 5, left: 5},
    orient: 'bottom',
    xValueAccessor: (d, idx) => [idx, d.label],
    yValueAccessor: (d) => window.parseInt(d.value),
    xAxis: false,
    xAxisType: 'ordinal',
    xAxisOrient: 'bottom',
    xAxisDrawLine: true,
    xAxisDrawTicks: true,
    xAxisDrawLabels: true,
    yAxis: true,
    yAxisType: 'log',
    yAxisOrient: 'left',
    yAxisDrawLine: true,
    yAxisDrawTicks: true,
    yAxisDrawLabels: true,
    onMouseOver: () => {
    },
    parentWidth: 700,
    parentHeight: 200
  };

  getXValues() {
    const {data, xValueAccessor} = this.props;

    const vals = data.map(xValueAccessor);


    return [vals.map(([k]) => k), _.fromPairs(vals)];
  }

  getYValues() {
    const {data, yValueAccessor} = this.props;

    return data.map(yValueAccessor);
  }

  renderAxis(props) {
    return <Axis {...props} />;
  }

  renderXAxis(width, height, scale, mapping) {
    const {xAxis} = this.props;

    if (xAxis) {
      const {
        xAxisOrient: orient,
        xAxisTicks: ticks,
        xAxisTicksValues: ticksValues,
        xAxisInnerTickSize: innerTickSize,
        xAxisOuterTickSize: outerTickSize,
        xAxisTickPadding: tickPadding,
        xAxisTickFormat: tickFormat,
        xAxisDrawLine: drawLine,
        xAxisDrawTicks: drawTicks,
        xAxisDrawLabels: drawLabels
      } = this.props;

      return this.renderAxis({
        width,
        height,
        scale,
        orient,
        ticks,
        ticksValues,
        innerTickSize,
        outerTickSize,
        tickPadding,
        tickFormat,
        drawLine,
        drawTicks,
        drawLabels,
        mapping,
        title: 'x'
      });
    } else {
      return null;
    }
  }

  renderYAxis(width, height, scale, mapping) {
    const {yAxis} = this.props;

    if (yAxis) {
      const {
        yAxisOrient: orient,
        yAxisTicks: ticks,
        yAxisTicksValues: ticksValues,
        yAxisInnerTickSize: innerTickSize,
        yAxisOuterTickSize: outerTickSize,
        yAxisTickPadding: tickPadding,
        yAxisTickFormat: tickFormat,
        yAxisDrawLine: drawLine,
        yAxisDrawTicks: drawTicks,
        yAxisDrawLabels: drawLabels
      } = this.props;

      return this.renderAxis({
        width,
        height,
        scale,
        orient,
        ticks,
        ticksValues,
        innerTickSize,
        outerTickSize,
        tickPadding,
        tickFormat,
        drawLine,
        drawTicks,
        drawLabels,
        mapping,
        title: 'y'
      });
    } else {
      return null;
    }
  }

  getXScale(width, values) {
    const {xAxisType} = this.props;

    if (_.isString(xAxisType)) {
      return this.getScale(
        xAxisType,
        [0, width],
        values
      );
    } else if (_.isFunction(xAxisType)) {
      return xAxisType(values, [0, width]);
    } else {
      throw new Error(`BarChart's xAxisType cannot be '${xAxisType}'`);
    }
  }

  getYScale(height, values) {
    const {yAxisType} = this.props;

    if (_.isString(yAxisType)) {
      const minValue = d3.min(values),
        maxValue = d3.max(values);

      return this.getScale(
        yAxisType,
        [0, height],
        [minValue, maxValue]
      );
    } else if (_.isFunction(yAxisType)) {
      return yAxisType(values, [0, height]);
    } else {
      throw new Error(`BarChart's yAxisType cannot be '${yAxisType}'`);
    }
  }

  getScale(type, range, domain) {
    let [minValue, maxValue] = domain;

    switch (type) {
      case 'ordinal':
        return d3.scale.ordinal()
          .rangeBands(range, 0.25)
          .domain(domain);

      case 'linear':
        if (minValue === maxValue) {
          minValue = 0;
        }

        return d3.scale.linear()
          .domain([minValue, maxValue])
          .range(range);

      case 'log':
        if (minValue < 1) {
          minValue = 1;
        }

        if (maxValue < 10) {
          maxValue = 10;
        }

        if (minValue === maxValue) {
          maxValue = roundUp(maxValue);

          if (minValue / 10 > 1) {
            minValue = roundUp(minValue / 10) / 10;
          }
        }

        return d3.scale.log()
          .domain([minValue, maxValue])
          .range(range)
          .nice();

      default:
        throw new Error(`BarChart's getScale doesn't support type='${type}'`);
    }
  }

  render() {
    const {parentWidth, parentHeight, margins, dataMargins, orient} = this.props,
      innerWidth = Math.abs(parentWidth - (margins.left + margins.right)),
      innerHeight = Math.abs(parentHeight - (margins.top + margins.bottom)),
      innerDataWidth = Math.abs(innerWidth - (dataMargins.left + dataMargins.right)),
      innerDataHeight = Math.abs(innerHeight - (dataMargins.top + dataMargins.bottom)),
      transform = `translate(${margins.left}, ${margins.top})`;

    const [xs, xMapping] = this.getXValues(),
      ys = this.getYValues();

    let xScale, yScale;

    // rotate chart by 90*
    switch (orient) {
      case 'left':
      case 'right':
        xScale = this.getYScale(innerDataWidth, ys);
        yScale = this.getXScale(innerDataHeight, xs);
        break;

      case 'top':
      case 'bottom':
        xScale = this.getXScale(innerDataWidth, xs);
        yScale = this.getYScale(innerDataHeight, ys);
        break;

      default:
        throw new Error(`BarChart doesn't support orient='${orient}'`);
    }

    return (
      <Chart width={parentWidth} height={parentHeight} className={this.props.className}>
        <g className="chart-bar" transform={transform}>
          <DataSeries values={_.zip(ys, xs)}
                      width={innerDataWidth}
                      height={innerDataHeight}
                      margins={dataMargins}
                      orient={orient}
                      xScale={xScale}
                      yScale={yScale}
                      onMouseOver={this.props.onMouseOver}
                      tooltipData={this.props.data}/>
          {this.renderXAxis(innerDataWidth, innerDataHeight, xScale)}
          {this.renderYAxis(innerDataWidth, innerDataHeight, yScale, xMapping)}
        </g>
      </Chart>
    );
  }
};

export default BarChart;
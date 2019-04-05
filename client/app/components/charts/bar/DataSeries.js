import React from 'react';
import PropTypes from 'prop-types';
import _ from 'lodash';

import Bar from './Bar';

export default class DataSeries extends React.Component {

  static propTypes = {
    tooltipData: PropTypes.array.isRequired,
    values: PropTypes.array.isRequired,
    height: PropTypes.number.isRequired,
    orient: PropTypes.oneOf(['left', 'top', 'right', 'bottom']),
    margins: PropTypes.object.isRequired,
    xScale: PropTypes.func.isRequired,
    yScale: PropTypes.func.isRequired,
    onMouseOver: PropTypes.func
  };

  static defaultProps = {
    onMouseOver: () => {
    }
  };

  render() {
    const {width, height, margins, tooltipData} = this.props,
      transform = `translate(${margins.left}, ${margins.top})`,
      {xScale, yScale, orient, values} = this.props;
    let barWidth, barHeight, barBgSize, x, y;

    switch (orient) {
      case 'left':
        barHeight = yScale.rangeBand();
        barBgSize = width;
        x = 0;
        break;

      case 'top':
        barWidth = xScale.rangeBand();
        barBgSize = height;
        y = 0;
        break;

      case 'right':
        barHeight = yScale.rangeBand();
        barBgSize = width;
        break;

      case 'bottom':
        barWidth = xScale.rangeBand();
        barBgSize = height;
        break;

      default:
        throw new Error(`DataSeries does not support orient='${orient}'`);
    }

    const bars = values.map(([point, label], idx) => {
      const tooltip = tooltipData[idx].value.toString().concat(' (', tooltipData[idx].label, ')');

      switch (orient) {
        case 'left':
          barWidth = xScale(point);
          y = yScale(label);
          break;

        case 'top':
          barHeight = yScale(point);
          x = xScale(label);
          break;

        case 'right':
          barWidth = xScale(point);
          x = width - xScale(point);
          y = yScale(label);
          break;

        case 'bottom':
          barHeight = yScale(point);
          x = xScale(label);
          y = height - yScale(point);
          break;

        default:
          throw new Error(`DataSeries doesn't support orient='${orient}'`);
      }

      if (_.isNaN(barWidth)) {
        barWidth = 0;
      }

      if (_.isNaN(barHeight)) {
        barHeight = 0;
      }

      if (_.isNaN(x)) {
        x = 0;
      }

      if (_.isNaN(y)) {
        y = 0;
      }

      return (
        <Bar width={barWidth}
             height={barHeight || 0}
             x={x}
             y={y}
             bgSize={barBgSize}
             orient={orient}
             key={idx}
             index={idx}
             onMouseOver={this.props.onMouseOver}
             tooltip={tooltip}/>
      );
    });

    return (
      <g className="chart-bar-data-series" transform={transform}>
        {bars}
      </g>
    );
  }
};
